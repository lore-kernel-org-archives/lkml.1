Return-Path: <linux-kernel-owner+w=401wt.eu-S933563AbYD3Uqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563AbYD3Uqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933317AbYD3UqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:46:23 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:19020 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122AbYD3UqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:46:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=oBqwPGj7koBYlfUd7kE3fM6vJYZ0pg361SX/Ayi8jzmQFeVhv5iWSiftuSgvRd+whBSATTS6vAYocqBq/uB9EVGiAUZUuAehm1KP5iwkITX1JRdsxIzyOggwvHV91Le24klQFhwL2H5BkuVVd3KsZT0/xzkoM6F4Q75IeTmv0tI=
Message-ID: <4818DA98.4040001@bellsouth.net>
Date: Wed, 30 Apr 2008 15:46:16 -0500
Reply-To: jacliburn@bellsouth.net
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Gabriel C <nix.or.die@googlemail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, linux-pm@lists.linux-foundation.org,
       pavel@suse.cz, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Some sort corruption of my Thermal Subsystem after suspend to
 ram
References: <4818D9AB.3040402@googlemail.com>
In-Reply-To: <4818D9AB.3040402@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
From: Jay Cliburn <jcliburn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Hi all,
> 
> I thought I've found all issue with that new box but I was wrong ;)
> 
> On an ASUS P5E-VM DO , 4G RAM , Q9300 CPU after suspend to ram Thermal 
> Subsystem gets corrupted in some way.

Does this board contain an Attansic L1 NIC?

> 
> I got some reboot , halt problems and was hunting the issue and noticed these problems only
> occurred when I've suspend the box to ram , at least once.
> 
> I've tested 2.6.{24*,25,linus-git(before ACPI merge),x86-latest-git} and all got that problem.
> 
> Also on x86-latest-git I've tested with MTRR_SANITIZER on/off. It does not make any difference.
> 
> 
> lspci output before s2r is :
> 
> ..
> 
> 
> 00:1f.6 Signal processing controller [1180]: Intel Corporation 82801I (ICH9 Family) Thermal Subsystem [8086:2932] (rev 02)
>         Subsystem: ASUSTeK Computer Inc. Device [1043:8277]
>         Flags: fast devsel
>         Memory at fed08000 (64-bit, non-prefetchable) [size=4K]
>         Capabilities: [50] Power Management version 3                                                                                                       
> 
> ...
> 
> 
> and after :
> 
> ...
> 
> 00:1f.6 Signal processing controller [1180]: Intel Corporation 82801I (ICH9 Family) Thermal Subsystem [8086:2932] (rev ff) (prog-if ff)
>         !!! Unknown header type 7f
> 
> ...
> 
> dmesg | grep 00:1f.6
> [21520.103062] PM: Writing back config space on device 0000:00:1f.6 at offset f (was ffffffff, writing 300)
> [21520.103066] PM: Writing back config space on device 0000:00:1f.6 at offset e (was ffffffff, writing 0)
> [21520.103070] PM: Writing back config space on device 0000:00:1f.6 at offset d (was ffffffff, writing 50)
> [21520.103074] PM: Writing back config space on device 0000:00:1f.6 at offset c (was ffffffff, writing 0)
> [21520.103078] PM: Writing back config space on device 0000:00:1f.6 at offset b (was ffffffff, writing 82771043)
> [21520.103083] PM: Writing back config space on device 0000:00:1f.6 at offset a (was ffffffff, writing 0)
> [21520.103087] PM: Writing back config space on device 0000:00:1f.6 at offset 9 (was ffffffff, writing 0)
> [21520.103091] PM: Writing back config space on device 0000:00:1f.6 at offset 8 (was ffffffff, writing 0)
> [21520.103095] PM: Writing back config space on device 0000:00:1f.6 at offset 7 (was ffffffff, writing 0)
> [21520.103099] PM: Writing back config space on device 0000:00:1f.6 at offset 6 (was ffffffff, writing 0)
> [21520.103103] PM: Writing back config space on device 0000:00:1f.6 at offset 5 (was ffffffff, writing 0)
> [21520.103107] PM: Writing back config space on device 0000:00:1f.6 at offset 4 (was ffffffff, writing fed08004)
> [21520.103111] PM: Writing back config space on device 0000:00:1f.6 at offset 3 (was ffffffff, writing 0)
> [21520.103115] PM: Writing back config space on device 0000:00:1f.6 at offset 2 (was ffffffff, writing 11800002)
> [21520.103119] PM: Writing back config space on device 0000:00:1f.6 at offset 1 (was ffffffff, writing 100002)
> [21520.103123] PM: Writing back config space on device 0000:00:1f.6 at offset 0 (was ffffffff, writing 29328086)
> 
> ..
> 
> 
> Please let me know if you need my config , dmesg or any other informations.
> 
> 
> Best Regards,
> 
> Gabriel C
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

