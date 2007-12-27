Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbXL0EWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbXL0EWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 23:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbXL0EVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 23:21:55 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:57627 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbXL0EVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 23:21:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=YpmI61KSIZRGDxn/j2J7jbsgYCJkN/Uoe3xtdplV6weouQxjQiuY6kQXY162dtmhwPC4vs9omrLkEQ0DPQLvIxddljoISJarUgYQvXrMTMB7IyfFe9nZRigpfv/dvLvtI+Pqtef9ZDbhTPtEGkscZHsQDHpf1Szu/APoqyLjKBA=
Message-ID: <47732853.3010208@gmail.com>
Date: Thu, 27 Dec 2007 13:21:39 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 7/7] sg_ring: convert core ATA code to sg_ring.
References: <200712191731.26512.rusty@rustcorp.com.au> <200712191838.27363.rusty@rustcorp.com.au> <47721294.7030401@gmail.com> <200712271124.31511.rusty@rustcorp.com.au>
In-Reply-To: <200712271124.31511.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rusty.

Rusty Russell wrote:
> On Wednesday 26 December 2007 19:36:36 Tejun Heo wrote:
>> It would be better to build upon sg chaining as we already have it.  I
>> think it can be made much easier with a bit more safe guards,
>> generalization and some helpers.
> 
>     I did this work to replace sg chaining.  The current chaining code gives 
> us longer sgs, and (if used carefully) the ability to append in some 
> circumstances.  But it's clumsy, and we can do better.  This is my attempt.

Ah.. okay.  That makes sense then.  I fully agree that sg chaining as it
currently stands is pretty ugly to use.  Appending extra entries
requires reserving one extra space in the sg list to be appended to
accommodate the last entry of the original list, which will be used for
chaining now.  Also, it's quite brittle in that information can get out
of sync easily (there's no one API for sg list manipulation, things have
to be done manually).

>     I understand that people are experiencing whiplash from the idea of 
> another change just after the sg chaining changes which have already gone in.  
> 
>     At the very least, I think I'll have to come up with a better transition 
> plan for SCSI drivers, rather than trying to convert them all at once... In 
> theory, sg chaining can be done through the sg ring arrays, but that's pretty 
> horrible.

I don't necessarily think large one time conversion is bad.  They're
necessary at times and make sense when they can increase long term
maintainability of the code.  One thing I'm concerned about is the
mixture of sg chaining and sg ring.  It would be best if we can agree on
conversion plan (or sg chaining extension plan).

Thanks.

-- 
tejun
