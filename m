Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYH2IE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYH2IE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbYH2IDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:03:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:36050 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989AbYH2IDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:03:35 -0400
Message-ID: <48B7AD11.2070906@kernel.org>
Date: Fri, 29 Aug 2008 10:02:25 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] uevent: handle duplicate uevent_var keys properly
References: <48B6D28E.10006@kernel.org> <48B6D2C6.4010703@kernel.org>	 <20080828164924.GB17475@kroah.com> <48B6D9B7.2050406@kernel.org> <3ae72650808290048v1a5d7e51pc68270b2a8d6faa@mail.gmail.com>
In-Reply-To: <3ae72650808290048v1a5d7e51pc68270b2a8d6faa@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 29 Aug 2008 08:03:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> Not sure if I understand that correctly. Remember, that there is a
> symlink "subsystem" at each device, and udev, HAL, DeviceKit reads it.
> If the uevent environment key "SUBSYSTEM" does not match the symlink
> target, things will break horribly. So no device can be a member of
> class "cuse" but carry a SUBSYSTEM value of a different class.
>
> If that is how it works, I guess that must be solved differently, by
> hooking into the subsystem code and create "virtual devices" at the
> original class they fake, instead of their own "cuse" class. Possibly
> by making cuse a "bus", and use the cuse device as a parent for the
> "real" class device.

For OSS emulation, it didn't really matter.  For cases where it matters,
I think easier path to take would be let the userland emulation set up a
directory containing pseudo files and just override DEVPATH to it.
Would that work?

Thanks.

-- 
tejun
