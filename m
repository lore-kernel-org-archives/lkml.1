Return-Path: <linux-kernel-owner+w=401wt.eu-S1762600AbYGOTud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762600AbYGOTud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 15:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbYGOTuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 15:50:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753076AbYGOTuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 15:50:25 -0400
Date: Tue, 15 Jul 2008 12:49:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Marcel Holtmann <marcel@holtmann.org>, Frans Pop <elendil@planet.nl>,
       jeff@garzik.org, arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
In-Reply-To: <1216150616.27455.377.camel@shinybook.infradead.org>
Message-ID: <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>  <20080714164119.99c33d5b.akpm@linux-foundation.org>  <20080714165956.7fe2d4ee@infradead.org> <487C0365.5030203@garzik.org>  <487C0365.5030203@garzik.org>  <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org>
  <200807151757.10626.elendil@planet.nl>  <1216149637.27242.65.camel@violet.holtmann.net>  <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org> <1216150616.27455.377.camel@shinybook.infradead.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, David Woodhouse wrote:
> 
> I'm unconvinced that the kernel should be setting this kind of policy.

I do think it should probably be conditional, but I think that's true of 
udevd itself too, so hey, it cuts both ways.

> But I suppose if you make it tunable in sysfs and just switch to calling
> do_filp_open() directly from firmware_class.c instead of punting to
> userspace, that might work.

Yup. And then you can disable it either statically (config option) or by 
writing an invalid path into /proc/sys/kernel/firmware-dir or whatever.

Or you can just decide that if you find something in the kernel-specific 
firmware directory, then it should always take precedence over whatever 
udev rules. Which sounds good to me anyway.

Maybe you really do have some very kernel-specific issue (ie you're trying 
a new driver that can handle a new experimental firmware, but you don't 
want your old fall-back kernels to use it because you just fixed the bug 
that makes it work again).

Requiring you to write udevd scripts for that sounds insane. I wouldn't 
even know where to start.

So kernel-specific directories do make sense. As does the whole "I don't 
want to handle the pain that is udev scripts".

			Linus
