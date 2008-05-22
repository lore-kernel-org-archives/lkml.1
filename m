Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbYEVObu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbYEVObu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 10:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYEVObj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 10:31:39 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:33852 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbYEVObi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 10:31:38 -0400
Message-ID: <483583C4.1080202@aitel.hist.no>
Date: Thu, 22 May 2008 16:31:32 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Bosko Radivojevic <bosko.radivojevic@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Inserting code from userspace to kernel space
References: <d6c8ef150805220541v711c5acahc60541e3fd9f44fc@mail.gmail.com>
In-Reply-To: <d6c8ef150805220541v711c5acahc60541e3fd9f44fc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bosko Radivojevic wrote:
> Hi!
>
> I'm looking for a way to insert code from user space to the kernel
> space, but without using kernel module. Actually, we are working on a
> system that has to allow end user to change part of code (one or two
> functions) that is executed from the kernel space.
>
> For now we have two different kernel modules, one exporting a function
> which another module uses. Process of compiling kernel module is quite
> ineligible for standard end user (along with the requirement to
> support multi platform cross compiling) compared to just cross
> compiling a simple code that doesn't use any libraries than libc.
>
> I know this sounds quite weird, but maybe there is a project that can help us ;)
>   
Consider telling exactly what you want to do, what is this for?
Perhaps there is a better/more standard way of doing it.

Looks like your end users are capable of compiling ordinary code
but not kernel modules? If this is so, consider just automating
the kernel module part for them. I.e. provide a module that call
a function, they can then make that function and you can make a script
that link their function with your kernel module. Then they won't need
to know much about kernel modules.

But the kernel module can't use libc (and what would you want to
use libc for anyway? libc mostly helps userspace communicate
with the kernel, no _need_ for that when your code is in the
kernel already.)

Or do you merely need your kernel code to run a user supplied program
now and then?  The kernel code can't call userspace code directly,
but you could make a device driver for this purpose.

The userspace code can read from the device, and block. When the kernel
need to run userspace code, it unblocks the userspace program.  If you
need to transfer data to userspace, simply let the userpace program
read the data from your device. and write stuff back, if needed.




