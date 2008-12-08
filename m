Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbYLHNb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbYLHNb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 08:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYLHNbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 08:31:15 -0500
Received: from mail2.shareable.org ([80.68.89.115]:37830 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbYLHNbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 08:31:14 -0500
Date: Mon, 8 Dec 2008 13:31:06 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Laurent Pinchart <laurentp@cse-semaphore.com>
Cc: linux-mtd@lists.infradead.org, dedekind@infradead.org,
       v4l-dvb-maintainer@linuxtv.org, LKML <linux-kernel@vger.kernel.org>,
       arnd@arndb.de
Subject: Re: UBI/DVB ioctl conflict?
Message-ID: <20081208133106.GA16354@shareable.org>
References: <20081207095811.13b51cca@zod.rchland.ibm.com> <1228717226.13686.89.camel@sauron> <200812081041.14178.laurentp@cse-semaphore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812081041.14178.laurentp@cse-semaphore.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart wrote:
> Correct me if I'm wrong, but doesn't this only matters for devices
> that would implement both the UBI and DVB API on the same inode ?
> That would be quite unlikely.

Overlapping ioctls prevent strace(1) from showing ioctls properly.

For example, here's something you see often in strace of programs
using stdio, when it calls isatty():

ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbfaaa864) = -1 ENOTTY (Inappropriate ioctl for device)

Or if it is a terminal:

ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {c_iflags=0x6d02, c_oflags=0x5, c_cflags=0x4bf, c_lflags=0x8a3b, c_line=0, c_cc="\x03\x1c\x7f\x15\x04\x00\x01\xff\x11\x13\x1a\xff\x12\x0f\x17\x16\xff\x00\x00"}) = 0

-- Jamie
