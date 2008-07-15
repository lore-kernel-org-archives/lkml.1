Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYGOE7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYGOE7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 00:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYGOE7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 00:59:34 -0400
Received: from 1wt.eu ([62.212.114.60]:3969 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbYGOE7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 00:59:33 -0400
Date: Tue, 15 Jul 2008 06:58:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, arjan@infradead.org,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Message-ID: <20080715045848.GG1369@1wt.eu>
References: <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <487C09EB.1050903@garzik.org> <alpine.LFD.1.10.0807141928540.3017@woody.linux-foundation.org> <20080714.194032.117461306.davem@davemloft.net> <alpine.LFD.1.10.0807141947540.3017@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807141947540.3017@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 07:51:55PM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 14 Jul 2008, David Miller wrote:
> > 
> > Jeff's not against request_firmware() in an of itself.
> > 
> > He's against the fact that it's not possible to build a
> > self-contained foo.ko module file any longer, and that
> > would definitely be possible with using request_firmware().
> 
> .. but is it really that big of a deal?
> 
> If it were about not being able to build a self-contained non-modular 
> "vmlinux", I'd be upset too.
> 
> But once you can load a module, you can load the firmware. You just have 
> to _remember_ to move it along with the module.

In order to transfer it, right now you feed it through a working device.
When that device itself requires firmware to work, you will suddenly
discover that it becomes harder and harder to get any communication device
to work on your target system.

Then, in order to load it, you need to have a properly set up system
(hotplug scripts, firmware at the proper location, etc...). This is
really not convenient on embedded systems or live CD systems. In fact,
among all my machines, only my notebook is currently able to load a
firmware.

Also, there's a versionning problem. It's easy to rename a driver
"foo.ko" => "foo-1.ko" and just load the exact file or hold several
versions there by simply moving a symlink. Having to fiddle around
with firmware files depending on the driver version will get much
harder.

Also, when you're cleaning up a system after installation, how do
you know which firmware files you need to keep and which ones you
can safely remove ?

Just like Jeff and Davem, I really want to be able to continue to
use my drivers like I have done since modules were introduced.
Switching a single-file to a multi-file/multi-dir installation would
be a huge maintenance regression IMHO.

Willy

