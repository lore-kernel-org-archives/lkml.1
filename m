Return-Path: <linux-kernel-owner+w=401wt.eu-S932735AbXAXVsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735AbXAXVsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 16:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932734AbXAXVsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 16:48:42 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:44007 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932735AbXAXVsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 16:48:41 -0500
Date: Wed, 24 Jan 2007 16:48:40 -0500
To: Paul Fulghum <paulkf@microgate.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange problem with tty layer
Message-ID: <20070124214840.GC7584@csclub.uwaterloo.ca>
References: <20070124204009.GA7584@csclub.uwaterloo.ca> <45B7CDB5.7020909@microgate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45B7CDB5.7020909@microgate.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 03:20:53PM -0600, Paul Fulghum wrote:
> In 2.6.16 the tty buffering pushes data to the line
> discipline without regard to tty->receive_room.
> If the line discipline can't keep up, the data gets dropped.
> I observed this data loss at higher speeds when
> placing the system under heavy load.
> 
> 2.6.18 added code to respect tty->receive_room.
> 
> This may or may not be your problem, but you should
> be able to check by adding a conditional printk
> to drivers/char/tty_io.c:flush_to_ldisc()
> 
> If tty->receive_room is less than the size of the buffer
> passed to disc->receive_buf() then you are losing data.

Sounds plausible.  Certainly higher cpu load makes the problem occour
more often, and making the system slower made it worse too.  I will take
a look at the tty_io.c in 2.6.18 and compare it against 2.6.16.

--
Len Sorensen
