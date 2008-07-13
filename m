Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYGMPuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYGMPuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 11:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbYGMPuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 11:50:12 -0400
Received: from THAUM.MIT.EDU ([18.95.3.27]:59577 "EHLO luto.stanford.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751482AbYGMPuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 11:50:11 -0400
Message-ID: <487A2431.2050103@myrealbox.com>
Date: Sun, 13 Jul 2008 11:50:09 -0400
From: Andy Lutomirski <luto@myrealbox.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
References: <200807010148.02135.rjw@sisk.pl> <200807122253.32382.rjw@sisk.pl> <48793A0E.3050803@myrealbox.com> <200807130133.12324.rjw@sisk.pl> <20080713091524.GA29907@elte.hu> <20080713120253.GA27582@srcf.ucam.org>
In-Reply-To: <20080713120253.GA27582@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Sun, Jul 13, 2008 at 11:15:24AM +0200, Ingo Molnar wrote:
> 
>> we still need to find the HAL quirk and disable it, right?
> 
> Not without understanding what the cause is. If the video BIOS calls are 
> generically broken, then we have a problem.
> 

The HAL quirk is the very first one here:

http://gitweb.freedesktop.org/?p=hal-info.git;a=blob;f=fdi/information/10freedesktop/20-video-quirk-pm-lenovo.fdi

I removed it from the HAL config and suspending w/ the hardware button 
works fine now with -rc9-wl and on Ubuntu's stock .24 kernel.

I'll file the obvious bug report against HAL, but it might annoy users 
if new kernel + old HAL = broken system, when the old kernel worked 
fine.  An alternative might be to make the change in 4b4f7280 
conditional on a new acpi_video_flags quirk so that previously-working 
systems keep working.

The quirk that actually breaks is s3_bios.  s3_mode still works, and 
power/video.txt says:

(2) systems where it is possible to call the video BIOS during S3
   resume. Unfortunately, it is not correct to call the video BIOS at
   that point, but it happens to work on some machines. Use
   acpi_sleep=s3_bios.

--Andy
