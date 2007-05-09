Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbXEIKxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbXEIKxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbXEIKxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:53:24 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:32791 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbXEIKxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:53:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: yhlu <yhlu.kernel@gmail.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       vgoyal@in.ibm.com, Gerd Hoffmann <kraxel@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <4634483E.9030307@goop.org> <4640FB2C.2060300@zytor.com>
	<86802c440705081541v7d0773cek2c5fae1854b68bbc@mail.gmail.com>
	<46410403.4050802@zytor.com>
	<m17irivkhy.fsf@ebiederm.dsl.xmission.com>
	<46413087.2020505@zytor.com>
	<m1tzumu10k.fsf@ebiederm.dsl.xmission.com>
	<86802c440705082152g49d4d3echf3eb165ce4feb2e9@mail.gmail.com>
	<46415640.6000600@zytor.com> <4641573C.1000205@zytor.com>
	<86802c440705082248r5248aa08s8299e03f615b984a@mail.gmail.com>
	<46416246.9090005@zytor.com>
Date: Wed, 09 May 2007 04:52:08 -0600
In-Reply-To: <46416246.9090005@zytor.com> (H. Peter Anvin's message of "Tue,
	08 May 2007 22:55:18 -0700")
Message-ID: <m1abwetgkn.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> yhlu wrote:
>> so the kexec tools need to scan the pci devices list, and find out how
>> to set real_mode.isVGA and orig_video_mode, also need to parse the
>> comand line about vga console.
>
> BTW, welcome to the hell of bypassing setup.

Well in this case things are so very much better then attempting to
us setup.S it isn't a real option.

In general BIOS calls just don't work reliably after linux has
been running for a while.

As for YH's point it does look like there are a few ways
to poke the linux kernel to see what is happening.

We can look in /proc/ioports and see what has reserved
the video resources.  That should give us a reasonable
estimate of the video adapter.  We can do an ioctl to
the console and see how many lines and columns we have.

Reusing boot_params could be nice but if we have the information
available in other ways digging it out that way is quite possibly
better.


Eric
