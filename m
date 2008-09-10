Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbYIJHOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbYIJHOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 03:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbYIJHOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 03:14:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:48635 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYIJHOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 03:14:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pvjPB/FOegRoPhu+fzqklHSGH7/nuKv2sF3//se/WanQE+fiu6C9G5rvTKez9Z4Yzo
         3TYfXopIW36ieSGwYknS/DvHRC2EKp/IOVDTPOuvDGRi6cY4Lj+nqxOafMvO4UgULB9P
         qd+4Fd/dC9lNjJqbeKYexH4ulwhK54B/h8eqI=
Message-ID: <48C78246.7050507@gmail.com>
Date: Wed, 10 Sep 2008 11:46:06 +0330
From: "Hamid R. Jahanjou" <hamid.jahanjou@gmail.com>
Reply-To: hamid.jahanjou@gmail.com
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Zan Lynx <zlynx@acm.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VM: Implements the swap-out page-clustering technique
References: <48BFCECE.90103@gmail.com>	<87iqtbuez9.fsf@basil.nowhere.org>	<48C19648.8030002@gmail.com>	<20080905194501.GZ18288@one.firstfloor.org>	<20080906014214.22f28548@riellaptop.surriel.com>	<48C471AE.8060809@acm.org> <20080907205536.0d1937ff@riellaptop.surriel.com>
In-Reply-To: <20080907205536.0d1937ff@riellaptop.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On Sun, 07 Sep 2008 18:28:30 -0600
> Zan Lynx <zlynx@acm.org> wrote:
>   
>> Rik van Riel wrote:
>> [cut]
>>     
>>> On the other hand, you do want to avoid evicting data 
>>> that the process is still using, just because you are 
>>> swapping out a not recently referenced page on a
>>> nearby virtual address.
>>>       
>> How about writing the nearby pages to swap anyway and mark the still 
>> in-use pages as SwapCache.
>>     
>
> That is what will happen pretty much automatically.
>   

I agree. As you said, we have two conflicting requirements here: on the
one hand one likes to swap as many pages as to satisfy the backing
storage "proper block IO size," on the other hand, one should not make a
process lose too many pages.  The code needs tuning really, I'm going to
rewrite it making it more flexible according to the suggestion given on
the mailing list.

> Another thing the swap out page clustering code could
> do is move pages that were recently referenced back
> to the active list, so the VM will not have to scan
> those pages again.
>
>   

I think this is a very good idea, actually the code does this already.

Thanks.
