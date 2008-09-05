Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbYIET0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbYIET0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 15:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbYIET0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 15:26:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:18932 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbYIET0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 15:26:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Nzj4rD/vfVAEiCn1qqq0olvM4ZYnqw9Vg4Vso1d39AWT/v5op6ngEp5UyIBOqOEGa7
         MaI48RZqjB9dJVDp8TZjIkYfD8Bt+aKHdusloyCWueflZ7zP5bZnlfjHw5aRNfo68QhF
         wkdAlRjNSYOqhEDEnLcQmsmY/FeyZllFcCFwg=
Message-ID: <48C19648.8030002@gmail.com>
Date: Fri, 05 Sep 2008 23:57:52 +0330
From: "Hamid R. Jahanjou" <hamid.jahanjou@gmail.com>
Reply-To: hamid.jahanjou@gmail.com
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VM: Implements the swap-out page-clustering technique
References: <48BFCECE.90103@gmail.com> <87iqtbuez9.fsf@basil.nowhere.org>
In-Reply-To: <87iqtbuez9.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> "Hamid R. Jahanjou" <hamid.jahanjou@gmail.com> writes:
>
>   
>> From: Hamid R. Jahanjou
>>
>> Implements the idea of swap-out page clustering from *BSD for
>> Linux. Each time a candidate page is to be swapped out,
>> virtually-nearby pages are scanned to find eligible pages to be
>> swapped out too as a cluster. This technique increases the likelihood of
>> bringing in related data on a page fault and decreases swap space
>> fragmentation in the long run. Currently, Linux searches only
>> physically-nearby pages which is not optimal since, over time, physically-
>> adjacent pages may become unrelated.
>>
>> The code can be statically tuned. No benchmarks. I'm not sure whether
>> the added complexity is acceptable.
>>     
>
> Just some general comments:
>
> First I think virtual swap clustering is a great idea in theory and
> long overdue.  Hopefully the numbers will agree.
>
> In general the code would be much nicer if you didn't pass around 
> all that much in a structure (which is just a fancy way to have
> a function with lots of arguments) Perhaps try to restructure
> it a bit to make this smaller? Ideally clustering_info should disappear
> or at least get much smaller.
>   

Thanks for the review and the comments.
Do you consider the clustering_info struct to hurt the readability
of the code or there is some other technical reasons ?

> I didn't quite understand the "adjust the value of our search by
> the allocation order". The allocation order should be normally 0.
> I think having a tunable for the cluster sizes would be a good idea.
> At some point they might be even device dependent (e.g. on a flash
> device you would like to have them roughly erase block sized)
>   

The allocation order value is initially passed to the try_to_free_pages()
in __alloc_pages_internal() and its value can be well more than zero.
The clustering code adjusts the cluster size to the value of the allocation
order (in a non-linear fashion of course). In this sense the cluster
size is
not determined at compile time, but the parameters affecting it are.
Perhaps the term "statically-tunable" is appropriate here.

-- 
Hamid R. Jahanjou
(hamid.jahanjou@gmail.com) 

