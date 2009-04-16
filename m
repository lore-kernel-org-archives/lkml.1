Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbZDPVIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbZDPVIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 17:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZDPVH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 17:07:57 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:64410 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZDPVH5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 17:07:57 -0400
MIME-Version: 1.0
In-Reply-To: <cf4f48500904161339n627e2127k7e9b4abeb0621c28@mail.gmail.com>
References: <cf4f48500904161339n627e2127k7e9b4abeb0621c28@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 16 Apr 2009 23:07:40 +0200
Message-ID: <ac3eb2510904161407v242ada41tcd079e5a639a638d@mail.gmail.com>
Subject: Re: Basic rundown of udev?
To: John Moser <john.r.moser@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 22:39, John Moser <john.r.moser@gmail.com> wrote:
> I'm currently reading through umm... udevd.c for udev-141.  Trying to
> figure out how this thing works.

Udev stuff is usually handled at linux-hotplug@vger.kernel.org.

> Anyone care to give me a brief map?  It would help.  I'm just trying
> to figure out how udev talks to the kernel

Udev just listens to broadcasted events from the kernel.

Just run:
  udevadm monitor --kernel --env
and
  strace udevadm monitor --kernel
and you see what's going on.

> -- i.e. will what facilities
> would I have to implement to re-implement the kernel side of udev,
> let's say if I was to run udevd as-is on Darwin or NetBSD or
> something.

Udev uses the Linux kernel device tree exported by sysfs. It offers
simplified access to the internal device structures in the kernel. Not
sure what other platforms do here.

> How does it talk to the kernel?  And if you know off the
> top of your head, which source files (and functions?) am I looking at
> here?

The kernel sends the needed events from: lib/kobject_uevent.c, but
that does not include the driver core, which is in drivers/base/*, and
the exported device tree filesystem at fs/sysfs/*.

Good luck,
Kay
