Return-Path: <linux-kernel-owner+w=401wt.eu-S1764525AbXHFLIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764525AbXHFLIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 07:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764368AbXHFLHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 07:07:01 -0400
Received: from hu-out-0506.google.com ([72.14.214.230]:40606 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764307AbXHFLHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 07:07:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=tjUU+Jo+aW5pdILdmgf/dpLkwjovPfOMUHmSuFOQmne8T8L3pUmG25RV8tpnqICvClIWxBco6cE4OZ5niPH7oOHLE4QVoz8Bq+jsNFDQ0Oq4Z50Qn3w/Cdi7TyL1ezvXS3YW0w4+zzEYY9PGIA8y00jDx3xfrOAATuGUx0e+pa0=
Message-ID: <46B700C7.5090801@gmail.com>
Date: Mon, 06 Aug 2007 13:06:47 +0200
From: dragoran <drago01@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: allow non root users to set io priority "idle" ?
References: <46B6EDCB.6030806@gmail.com> <p73zm14lxyy.fsf@bingen.suse.de> <46B6F75D.1070808@gmail.com> <20070806103553.GA16133@one.firstfloor.org>
In-Reply-To: <20070806103553.GA16133@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> couldn't this be fixed by bumping idle tasks to middle while they hold a 
>>     
>
> Usually to high.
>
> But it's all complicated and hasn't been done consistently
> (there are real time mutexes in the -rt kernel for example, 
> but there are lots of other locks and they have higher overhead too) 
> and it's unclear we really want to do all this complexity anyways.
>
> Also as I said the problem could then still happen in user space
> which then would all need to be fixed to handle PI too.
>
> In some cases the relationship is also not as simple as a single 
> lock. And for IO handling it would be likely quite hard.
>
> I personally always found idle priorities quite dubious because
> even if they worked reliable for the CPU they will clear your cache/
> load your memory controller and impact all other programs because
> of this. And for the disk they will cause additional seeks which are 
> also very costly.
>
>   
ok, thx so that means that the best that can be done for now is to run 
beagle as best effort with prio 7 (like its done now).


