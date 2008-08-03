Return-Path: <linux-kernel-owner+w=401wt.eu-S1753072AbYHCBSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbYHCBSt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 21:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYHCBSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 21:18:40 -0400
Received: from aun.it.uu.se ([130.238.12.36]:49254 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbYHCBSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 21:18:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18581.1892.930044.26645@harpo.it.uu.se>
Date: Sun, 3 Aug 2008 03:18:28 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Brian Beattie <beattie@beattie-home.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ioctl's suck?
In-Reply-To: <1217714096.6280.35.camel@kokopelli>
References: <1217714096.6280.35.camel@kokopelli>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Beattie writes:
 > The other day Linus (I think) made the statement, that I don't disagree
 > with, that I will parapharse as "ioctl's suck".  If I recall correctly
 > and understand he was saying that a device that uses ioctls is broken.
...
 > I could add a control device and pass ascii strings for status and OOB
 > messages, would that be an improvement?

The problem is that the classical unix I/O abstraction really only handles
two cases well, viz. "read next chunk of data" and "write this data and
advance position". Anything else is seen as something strange.

ioctls() are the equivalent of device-specific RPCs (remote procedure
calls): you present some arguments and a call code, and you get some
results. Nothing wrong with that.

In practice however there are some pitfalls. For instance, ioctls()
are often abused for quick hacks with little concern for backwards
compatibility. So when someone changes an ioctl, and breaks user-space,
who gets the blame? ioctls in general! I would argue that that is
why, and the main reason why, some people put ioctls() down.

There may be something wrong with people abusing ioctls, but that
is not a problem with ioctls per se. (I can easily design broken
ABIs around read()/write()/open()-only interfaces.)
