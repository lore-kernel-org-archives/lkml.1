Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbZA1GhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbZA1GhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 01:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZA1GhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 01:37:09 -0500
Received: from omr10.networksolutionsemail.com ([205.178.146.60]:54945 "EHLO
	omr10.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486AbZA1GhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 01:37:08 -0500
Message-ID: <497FFD06.8010001@nerdgrounds.com>
Date: Tue, 27 Jan 2009 22:36:54 -0800
From: Jonathan Campbell <jon@nerdgrounds.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Eric Anholt <eric@anholt.net>
CC: Mark Knecht <markknecht@gmail.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
References: <497E4531.20800@nerdgrounds.com>	 <5bdc1c8b0901261859g58a413e1x52208a6f2c1f9ccd@mail.gmail.com>	 <1233031451.4851.31.camel@gaiman>	 <5bdc1c8b0901270937h27c48290p4fb5233f06593e44@mail.gmail.com> <1233091414.25539.8.camel@gaiman>
In-Reply-To: <1233091414.25539.8.camel@gaiman>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well my expectation of vramfs is that it's not meant to be used for the 
heavy-duty 3D gaming-style rendering that GEM is built to handle. It's 
meant for lighter tasks, like simple 2D/3D compositing or GPU work where 
you know what your resources need, you don't need to take that much, and 
you need direct mmap() access because some of it involves video that you 
will handle later. Situations like this can work perfectly fine without 
the use of a swapping system.

My other concern is that GEM with a filesystem might be the best option 
for 3D gaming, but that it wouldn't work if the driver doesn't know the 
card. The DRI drivers, as far as I know, are tied to the GPU and chipset 
of the device (because they have to manage it, after all!). How exactly 
would GEM work for cards that it doesn't recognize, like one machine of 
mine with a weird ATI chipset nobody knows how to talk to? If GEM 
doesn't recognize it, it won't provide VRAM resources to use it, right?

This is where vramfs has it's advantage: it's not the absolute best 
solution for 3D graphics, but it's simple, it can serve as a starting 
point for GPU experiments from userspace, or if nothing else allows the 
use of the onboard video RAM on an otherwise unused and unrecognized 
video device. It's device-agnostic by design.
> The way you want do that is using OpenGL to put your data in textures
> and framebuffer objects, and render them.  With KMS, we'll be able to
> support EGL even on the console so you can do the work without having an
> X environment set up.
>
> The problem with vramfs as a basis for GPU offload is that most GPU
> tasks end up at some point exceeding the size of available
> aperture/VRAM.  So you need code that manages loading buffer objects in
> and out on demand, managing the execution pipeline and GPU and CPU
> caches as required.  We have that with GEM already.
>
> Remember, writing data to an aperture isn't the hard part of offloading
> to the GPU, programming the GPU is.  That's why you use OpenGL or
> another abstraction to do it.
>
>   

