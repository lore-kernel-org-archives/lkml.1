Return-Path: <linux-kernel-owner+w=401wt.eu-S1752274AbXDNB5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbXDNB5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 21:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbXDNB5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 21:57:22 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:21828 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbXDNB5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 21:57:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QwRw4g+p2rQTH1biEoS2UsqtKHaHzebYwFxQAhFEZWu61eEdgOs3BBghI7ObM6ydtzeyEzdhRzgMIzSmWqzkTMbiwQCXYvqvKJ/9bs0oO3qLMRMONU1Rva/7FeCfn/dvLGEhkJco/HaTNHnPTSGfzX5/s4AceLczjczsm9TJ88k=
Subject: Re: [3/3] 2.6.21-rc6: known regressions
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Marcus Better <marcus@better.se>,
       James Simmons <jsimmons@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070414003808.GU5907@stusta.de>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
	 <20070414003808.GU5907@stusta.de>
Content-Type: text/plain
Date: Sat, 14 Apr 2007 09:57:03 +0800
Message-Id: <1176515823.4807.7.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-14 at 02:38 +0200, Adrian Bunk wrote:
> This email lists some known regressions in Linus' tree compared to 2.6.20.
> 
> If you find your name in the Cc header, you are either submitter of one
> of the bugs, maintainer of an affectected subsystem or driver, a patch
> of you caused a breakage or I'm considering you in any other way
> possibly involved with one or more of these issues.
> 
> Due to the huge amount of recipients, please trim the Cc when answering.
> 
> 
> Subject    : resume from RAM corrupts vesafb console
> References : http://lkml.org/lkml/2007/3/26/76
> Submitter  : Marcus Better <marcus@better.se>
> Handled-By : Pavel Machek <pavel@ucw.cz>
> Status     : problem is being debugged
> 
> 
Hi Marcus,

A screen with blinking green blocks implies that your display is in text
mode, not in graphics mode.  I don't know what options you are using,
but have you tried using:

acpi_sleep=s3_mode

If the above does not work, also try

acpi_sleep=s3_bios,s3_mode

If it is still not working, you can add this to your suspend script:

vbetool vbemode set <VESA mode ID>

where VESA mode ID = "vga=" value - 512 (0x200)

Tony

PS: If your BIOS setup has an option to re-POST the graphics card on
resume, that is a big help.

Tony


