Return-Path: <linux-kernel-owner+w=401wt.eu-S966992AbXJSV32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966992AbXJSV32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935576AbXJSV3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:29:18 -0400
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:39442 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757551AbXJSV3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:29:17 -0400
Message-ID: <471921AB.4070102@lwfinger.net>
Date: Fri, 19 Oct 2007 16:29:15 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: Locking problem in usbserial with 2.6.23-git 5a34417f
References: <4718D469.2080606@lwfinger.net> <Pine.LNX.4.64.0710192304590.18815@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0710192304590.18815@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Fri, 19 Oct 2007, Larry Finger wrote:
> 
>> While attempting to configure a new USB modem, the following locking 
>> problem occurred. In addition, shortly after this problem occurred, the 
>> computer froze. The log data starts at the point that usbserial was 
>> loaded and contains everything that was written to disk before the 
>> machine locked up. Some info may be missing from the end of the stack 
>> dump.
> 
> I guess this one is needed.
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> 
> USB: usbserial - fix potential deadlock between write() and irq
> 
> usb_serial_generic_write() doesn't disable interrupts when taking port->lock,
> and could therefore deadlock with usb_serial_generic_read_bulk_callback()
> being called from interrupt, taking the same lock. Fix it.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 

Yes, this patch did fix the locking problem.

Thanks,

Larry
