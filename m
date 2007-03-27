Return-Path: <linux-kernel-owner+w=401wt.eu-S934212AbXC0WMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212AbXC0WMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934216AbXC0WMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:12:09 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:56391 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934212AbXC0WMF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:in-reply-to:references:mime-version:content-type:message-id:cc:content-transfer-encoding:from:subject:date:to:x-mailer;
        b=S1X9nPslmOQ/BSFHYxcmdo35bVihEZyw87iO4/Gs7P2NlVnGv3JsHLBvbqbX4v3M2ckENcf/umDDYHUPlVCwWyvzjLwo979kuFWzPR1Yp6b5x0iV68WyvML5nCbd5YWS86pzO2XU/NXNyvWqyR4rIyOcjbBWT2ZYJW0VRWPrzH0=
In-Reply-To: <460964BA.8090101@garzik.org>
References: <Pine.LNX.4.64.0703241232580.11608@p34.internal.lan> <4608B2B9.7090503@garzik.org> <ACBD2F44-03C7-49BE-9A2F-ABF7078BCC5E@gmail.com> <460964BA.8090101@garzik.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=WINDOWS-1252; delsp=yes; format=flowed
Message-Id: <711F1620-F483-4CC2-83D6-F2DD577AB5BB@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
From: Mark Rustad <mrustad@gmail.com>
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
Date: Tue, 27 Mar 2007 17:12:00 -0500
To: Jeff Garzik <jeff@garzik.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 27, 2007, at 1:38 PM, Jeff Garzik wrote:

> Mark Rustad wrote:
>> reorder any queued operations. Of course if you really care about  
>> your data, you don't really want to turn write cache on.
>
> That's a gross exaggeration.  FLUSH CACHE and FUA both ensure data  
> integrity as well.
>
> Turning write cache off has always been a performance-killing  
> action on ATA.

Perhaps. Folks I work with would disagree with that, but I am not  
enough of a storage expert to judge. My statement mirrors the  
judgement of folks I work with that know more than I do.

>> Also the controller used can have unfortunate interactions. For  
>> example the Adaptec SAS controller firmware will never issue more  
>> than two queued commands to a SATA drive (even though the firmware  
>> will happily accept more from the driver), so even if an attached  
>> drive is capable of reordering queued commands, its performance is  
>> seriously crippled by not getting more commands queued up. In  
>> addition, some drive firmware seems to try to bunch up queued  
>> command completions which interacts very badly with a controller  
>> that queues up so few commands. In this case turning NCQ off  
>> performs better because the drive knows it can't hold off  
>> completions to reduce interrupt load on the host – a good idea  
>> gone totally wrong when used with the Adaptec controller.
>
> All of that can be fixed with an Adaptec firmware upgrade, so not  
> our problem here, and not a reason to disable NCQ in libata core.

It theoretically could be, but we are using the latest Adaptec  
firmware. Until there exists firmware that fixes it, it remains an  
issue. We worked with Adaptec to isolate this issue, but no  
resolution has been forthcoming from them. I agree that this does not  
mean that NCQ should be disabled in libata core, but some combination  
of controller/drive/firmware blacklist may need to be managed, as  
distasteful as that is.

>> Today SATA NCQ seems to be an area where few combinations work  
>> well. It seems so bad to me that a whitelist might be better than  
>> a blacklist. That is probably overstating it, but NCQ performance  
>> is certainly a big problem.
>
> Real world testing disagrees with you.  NCQ has been enabled for a  
> while now.  We would have screaming hordes of users if the majority  
> of configurations were problematic.

I didn't say that it is a majority or that it doesn't work, it just  
often doesn't perform. If it didn't work there would be lots of  
howling for sure. I'm also not saying that it is a libata problem. It  
seems mostly to be controller and drive firmware issues - and the odd  
fan issue (if you saw the thread: [BUG 2.6.21-rc3-git9] SATA NCQ  
failure with Samsum HD401LJ).

I guess I am mainly lamenting the current state of SATA/NCQ devices  
and sharing what little I have picked up about it - which is that I  
want SAS disks in my next system!

-- 
Mark Rustad, MRustad@gmail.com


