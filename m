Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbZFHWhC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbZFHWhC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 18:37:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbZFHWgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 18:36:54 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:34571 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755783AbZFHWgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 18:36:53 -0400
Message-ID: <4A2D9282.6080609@simtec.co.uk>
Date: Mon, 08 Jun 2009 23:36:50 +0100
From: Ben Dooks <ben@simtec.co.uk>
Organization: Simtec Electronics, UK
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: InKi Dae <daeinki@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Kyungmin Park <kmpark@infradead.org>
Subject: Re: Samsung SoC Framebuffer Driver issue.
References: <90b950fc0906072153j6308059eq4d6f864c97a2003d@mail.gmail.com>
In-Reply-To: <90b950fc0906072153j6308059eq4d6f864c97a2003d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

InKi Dae wrote:
> Hello,  Ben  Dooks.
> 
> I am trying to develop Samsung SoC Framebuffer Driver for S5PC100 but
> I faced some problems about design. so I have some questions about those.
> 
> there are some differences between LCD Controller registers of S3C64XX
> and S5PC100 like the following.
> 
> . regiters not used by S3C64XX were added to S5PC100 also BPP MODE.
> . WindowX Palette Data Index registers were removed from lcd
> controller of S3C64XX and Palette Memory Registers were added to one
> of S5PC100
> 
> 
> 1.
> Your framebuffer driver, drivers/video/s3c-fb.c, is related to only S3C64XX.
> and I'd like to divide framebuffer driver into common logical driver
> for supporting S3C64XX and S5PC100 and S5PC100 specific driver.
> but your driver needs to modifying because calling register control
> commands in s3c-fb.c directly.

Actually, it should also support the s3c2443 driver. You might find some
interesting answers to the further questions by looking at how that works
via the architecture specific includes.

> How do you think about that ?
> 
> 2.
> S3C64XX LCD Controller's registers are similar with S5PC100's, so I
> wouldn't modify register prefix.
> but some registers should added to definition file
> (arch/arm/mach-s3c6400/include/mach/regs-fb.h).

I don't have documentation for any of these newer chips, so cannot make
much of a comment without any more detailed data.

> which way do you prefer adding some registers to
> arch/arm/mach-s3c6400/include/mach/regs-fb.h or creating new
> definition file for S5PC100 ?
> 
> If you give me your comments for the issues above, I will modify
> Samsung SoC Framebuffer Driver to be supported for S3C64XX and
> S5PC100.
> In the result, I expect that your driver will be divided into logical
> driver and specific driver supporting S3C64XX and S5PC100 or either
> S3C64XX or S5PC100.
> If the driver would be completed, logical driver, s3c-fb.c, would
> support S3C64XX, S5PC100 and also S5PC110.

I'll let you have a think about this wrt to the answer supplied for #1,
and see if you need any further information about it after that.

> Please give me your comments and advices.
> 
> Best Regards,
> InKi Dae.


-- 
Ben Dooks, Software Engineer, Simtec Electronics

http://www.simtec.co.uk/
