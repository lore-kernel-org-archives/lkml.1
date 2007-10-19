Return-Path: <linux-kernel-owner+w=401wt.eu-S967272AbXJSWTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967272AbXJSWTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966839AbXJSWTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:19:24 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:36165 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966803AbXJSWTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:19:23 -0400
Message-ID: <47192D69.60203@lwfinger.net>
Date: Fri, 19 Oct 2007 17:19:21 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: Locking problem in usbserial with 2.6.23-git 5a34417f
References: <4718D469.2080606@lwfinger.net> <Pine.LNX.4.64.0710192304590.18815@twin.jikos.cz> <4719235E.9030507@lwfinger.net> <Pine.LNX.4.64.0710200001520.18815@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0710200001520.18815@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Fri, 19 Oct 2007, Larry Finger wrote:
> 
>> As I said earlier, the lock problem went away; however, I get the 
>> following two kernel warnings:
> 
> That's because I messed up the patch, sorry. The one below should work 
> better.
> 
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> 
> USB: usbserial - fix potential deadlock between write() and IRQ
> 
> usb_serial_generic_write() doesn't disable interrupts when taking port->lock,
> and could therefore deadlock with usb_serial_generic_read_bulk_callback()
> being called from interrupt, taking the same lock. Fix it.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

It does work better. With it, I was able to make a dial-up connection and send pings over it.

Larry

