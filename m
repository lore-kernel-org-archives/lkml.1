Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbZINWyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbZINWyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 18:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757468AbZINWyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 18:54:43 -0400
Received: from fifo99.com ([67.223.236.141]:37402 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467AbZINWym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 18:54:42 -0400
Subject: Re: [patch 3/6] add pmem driver
From: Daniel Walker <dwalker@fifo99.com>
To: Brian Swetland <swetland@google.com>
Cc: Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>, arve@android.com,
       kernel list <linux-kernel@vger.kernel.org>,
       Iliyan Malchev <malchev@google.com>,
       Petri Gynther <pgynther@google.com>
In-Reply-To: <a55d774e0909141519i752eca3dp7ab848e1c1154530@mail.gmail.com>
References: <20090914215855.GC11667@elf.ucw.cz>
	 <1252965980.11643.261.camel@desktop>
	 <a55d774e0909141519i752eca3dp7ab848e1c1154530@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 15:55:32 -0700
Message-Id: <1252968932.11643.299.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 15:19 -0700, Brian Swetland wrote:
> On Mon, Sep 14, 2009 at 3:06 PM, Daniel Walker <dwalker@fifo99.com> wrote:
> > On Mon, 2009-09-14 at 23:58 +0200, Pavel Machek wrote:
> >>
> >> This adds android pmem driver, one of dependencies of camera driver.
> >
> > I wouldn't even both with this one .. There's no way it could ever go
> > into mainline .. According to the android developers the camera , and
> > the frame buffer driver should work without it anyway..
> 
> The latest camera driver should work without pmem (or be fixable to do
> so -- I forget if that's done yet).
> 
> The framebuffer itself does not need pmem, but pmem is used heavily by
> the android userspace on dream/magic for hardware compositable
> surfaces (since the 2d compositor requires physically contiguous
> memory).
> 
> Is there a general linux kernel solution for managing large (1-8MB+)
> chunks of physically contiguous memory that needs to be shared between
> kernel and userspace for media operations?  This is a very common
> problem with these SoCs -- the a/v subsystem and/or GPU don't have
> scatter/gather or MMU support and as a result we need to carve out
> memory for their use and provide some way for userspace to manipulate
> it.

After out last conversation I found the the system calls
splice/vm-splice .. I don't know a great deal about those system call,
but from what I read that sounded like it would be the appropriate way
to transfer memory between two kernel drivers (i.e. camera to
framebuffer) ..

As for sharing it with userspace, I haven't really researched that
enough to give a good answer. I would think you could build something
into the camera driver that would expose the memory to userspace
temporarily then the camera could reclaim the memory later.

Daniel

