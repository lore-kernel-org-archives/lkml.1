Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbYJOIp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbYJOIp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 04:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYJOIpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 04:45:14 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:58219 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYJOIpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 04:45:12 -0400
Message-ID: <ac3eb2510810150145q4ee66c17xde59d966053d6e7f@mail.gmail.com>
Date: Wed, 15 Oct 2008 10:45:10 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Creating dev nodes from driver or via uevent?
In-Reply-To: <20081015063917.GA18487@true>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081015063917.GA18487@true>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 8:39 AM, Fabiano Sidler <lists@fipscode.ch> wrote:
> Probably a very basic question, but is it better to directly mknod from a
> module's init funtion or to use the uevent/udev mechanism?

You better do not touch any userspace managed filesystem from inside
the kernel. No driver is doing that.

> If the latter,
> are there good overviews, explanations and comprehensive code samples
> especially for using udev, as well as how to package the userspace program
> creating the nodes along with a driver?

You do not package anything along with the driver, unless you have
_very_ special requirements for userspace device setup. Then you could
ship a udev rules file.

There is nothing special to do, just run udev, and register a "struct
device" inside the kernel's driver core, and you will see a device
node in /dev/ with the name of your kernel device, and the major/minor
you assigned to the struct device before registration.

Almost every Linux distro, and every driver in the kernel works that
way. I suggest looking at the current kernel code and running a Linux
distro and loading/unloading an existing module, to see it working.

You can also run "/sbin/udevadm monitor --env --kernel" to see the
"raw" kernel events "struct device" registration causes, and which
lets userspace create the device nodes.

Kay
