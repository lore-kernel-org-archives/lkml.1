Return-Path: <linux-kernel-owner+w=401wt.eu-S1761539AbYGOCSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539AbYGOCSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 22:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761357AbYGOCRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 22:17:39 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:56249 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761310AbYGOCRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 22:17:38 -0400
Date: Mon, 14 Jul 2008 21:16:56 -0500
From: David Fries <david@fries.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 29/30] W1: Documentation/w1/masters/ds2490 update
Message-ID: <20080715021656.GQ5621@spacedout.fries.net>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru> <12157843071043-git-send-email-johnpol@2ka.mipt.ru> <20080714134002.e5dfaaae.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080714134002.e5dfaaae.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 14 Jul 2008 21:17:03 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 01:40:02PM -0700, Randy Dunlap wrote:
> > +- The number of USB bus transactions could be reduced if w1_reset_send
> > +  was added to the API.  The name is just a suggestion.  It would take
> > +  a write buffer and a read buffer (along with sizes) as arguments.
> > +  It would add match rom and rom to the send buffer, reset the bus,
>                   ~~~~~~~~~~~~~~~~~
> Can you clarify above?

I re-wrote the paragraph.  In the one wire protocol a bus reset is
followed by a one byte command, in this case match rom which tells all
the devices on the bus to expect an 8byte rom (slave device id) and
only the slave device that matches the rom is to respond to the
following message.  I was assuming people reading it would be familiar
with the one wire bus protocol.  Do you have any of the one wire
hardware?

- The number of USB bus transactions could be reduced if w1_reset_send
  was added to the API.  The name is just a suggestion.  It would take
  a write buffer and a read buffer (along with sizes) as arguments.
  The ds2490 block I/O command supports reset, write buffer, read
  buffer, and strong pullup all in one command, instead of the current
  1 reset bus, 2 write the match rom command and slave rom id, 3 block
  write and read data.  The write buffer needs to have the match rom
  command and slave rom id prepended to the front of the requested
  write buffer, both of which are known to the driver.  

The next paragraph was removed, I decided that listing the commands
giong from three to one was enough, I didn't need to count all the USB
bus transactions.

I'll send the patch again in the next e-mail.

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
