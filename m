Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbZAYBNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbZAYBNF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 20:13:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbZAYBMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 20:12:53 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:58182 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbZAYBMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 20:12:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=qaeXcMw/2EwoLyVOw3duD9IHVDxgpq7JnTEm55uBNLJJ/UMk3egKPcNhIvsCQlVIm5
         Bmp2LGbMwst5Sx+ebNJ979rcNBnkxR1jZMlJQPK3yK52lcVQXlKIZoCaB+t8KztWjlTi
         v6J0cddPVvmSpx6P7kofvBxDm5WeQ7joiWl+w=
Message-ID: <497BBC92.5090208@gmail.com>
Date: Sun, 25 Jan 2009 10:12:50 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Patrick Horn <patrick.horn@gmail.com>
CC: Diego Calleja <diegocg@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Faulty seagate drives, are going to be blacklisted?
References: <20090120002923.065f24ca@diego-desktop> <4976F89A.1040405@gmail.com>
In-Reply-To: <4976F89A.1040405@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Patrick.

Patrick Horn wrote:
...
> Is this error just coincidence, or did Seagate forget to mention my drive?
> (And what happened to the firmware updates--they seem to be "In
> Validation")
> Is seagate the only site with information about this? Any public
> blacklist of every affected drive? What can I see in dmesg that
> indicates that NCQ is the cause?

I think it's coincidental.  AFAIK, there was no report of increased
transmission failures.  Two known problems with these firmwares are

1. timeout on FLUSH if NCQ is in use on certain drives

2. bricking after power off (so, the failure is almost always during
   BIOS probing during boot)

> (I'll paste my dmesg as I don't know enough to tell if this is the same
> issue as the other seagate drives--I trimmed the repetitive parts)
> 
> [ 7520.699730] ata2.00: exception Emask 0x10 SAct 0x7ff4f SErr 0x400100
> action 0x6 frozen
> [ 7520.699734] ata2.00: irq_stat 0x08000000, interface fatal error
> [ 7520.699738] ata2: SError: { UnrecovData Handshk }

This is transmission error.  Most common causes are power related or
unreliable connection especially if backplanes are involved.  Is the
problem still reproducible?  If so, can you please try to move it to
different power connector and SATA port and see what changes?

Thanks.

-- 
tejun
