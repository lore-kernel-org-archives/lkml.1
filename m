Return-Path: <linux-kernel-owner+w=401wt.eu-S965485AbXBRAsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965485AbXBRAsK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 19:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965486AbXBRAsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 19:48:10 -0500
Received: from thunk.org ([69.25.196.29]:46133 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965485AbXBRAsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 19:48:07 -0500
Date: Sat, 17 Feb 2007 18:20:54 -0500
From: Theodore Tso <tytso@mit.edu>
To: Paul Fulghum <paulkf@microgate.com>
Cc: Mockern@yandex.ru, linux-kernel@vger.kernel.org
Subject: Re: serial and tty driver
Message-ID: <20070217232054.GA11117@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Paul Fulghum <paulkf@microgate.com>, Mockern@yandex.ru,
	linux-kernel@vger.kernel.org
References: <45D73BF6.000001.30155@pantene.yandex.ru> <45D74856.6090900@microgate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D74856.6090900@microgate.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 12:24:22PM -0600, Paul Fulghum wrote:
> Mockern wrote:
> >I have a question, what is really difference between serial and tty
> >drivers?
> >
> >As I understand tty is high level and communicates with user space. 
> 
> The serial core implements many of the details of a tty
> driver in a common place so that individual hardware drivers
> (serial drivers) only need implement the hardware specific code.
> 
> This prevents duplicating tty logic in many drivers,
> with the possibility of mistakes/inconsistency in the
> different tty drivers.
> 
> The stand alone tty drivers are mostly legacy code from
> the time before serial core that have not been ported
> to be a serial drivers.

Not necessarily; there are a number of tty drivers, such as the
console drivers and pseudo-tty drivers that have absolutely nothing to
do with an RS-232 port.

On the other side of the argument, another factorization of the layers
that might have made sense was to move the functionality to the
high-level tty layer (or in the case of hangup code, all the way up to
the VFS layer as a generic sys_revoke functionality), but the reason
why it didn't is largely historical.

						- Ted
