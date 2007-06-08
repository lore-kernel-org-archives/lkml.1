Return-Path: <linux-kernel-owner+w=401wt.eu-S969277AbXFHOGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969277AbXFHOGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968718AbXFHOGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:06:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51416 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S968710AbXFHOGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:06:24 -0400
Date: Fri, 8 Jun 2007 10:06:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Grant Wilson <gww@swandive.no-ip.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.22-rc4-mm1
In-Reply-To: <20070608042358.GB20483@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0706081001040.3473-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Greg KH wrote:

> On Thu, Jun 07, 2007 at 10:53:29AM -0400, Alan Stern wrote:
> > To tell you the truth, I rather think there's not much point in keeping
> > usb-try-to-debug-bug-8561.patch around.  Anything seriously wrong that
> > it could catch ought to have shown up long ago.  And it is now clear
> > that bug 8561 has nothing to do with this; it is a programming error
> > common to many of the USB serial drivers.  (Still waiting to hear back 
> > from Paulo Pereira whether the fix to the USB Option driver works...)
> 
> What error in the usb-serial drivers are you speaking about?

The one addressed by usb-option-fix-usage-of-urb-status-abuse.patch.  I 
thought it might be worthwhile to spend some time fixing all of these.
Here's a quick summary showing the extent of the problem (note that 
not all the usages are in error):

$ grep EINPROGRESS drivers/usb/serial/*.c drivers/usb/misc/*.c
drivers/usb/serial/digi_acceleport.c:*       return 256 when -EINPROGRESS is set, as the line discipline
drivers/usb/serial/digi_acceleport.c:		while( oob_port->write_urb->status == -EINPROGRESS
drivers/usb/serial/digi_acceleport.c:		while( (port->write_urb->status == -EINPROGRESS
drivers/usb/serial/digi_acceleport.c:	while( oob_port->write_urb->status == -EINPROGRESS
drivers/usb/serial/digi_acceleport.c:	if( port->write_urb->status == -EINPROGRESS
drivers/usb/serial/digi_acceleport.c:	if( port->open_count && port->write_urb->status != -EINPROGRESS
drivers/usb/serial/digi_acceleport.c:	if( port->write_urb->status == -EINPROGRESS
drivers/usb/serial/digi_acceleport.c:	if( port->write_urb->status == -EINPROGRESS
drivers/usb/serial/empeg.c:			if (write_urb_pool[i]->status != -EINPROGRESS) {
drivers/usb/serial/empeg.c:		if (write_urb_pool[i]->status != -EINPROGRESS) {
drivers/usb/serial/empeg.c:		if (write_urb_pool[i]->status == -EINPROGRESS) {
drivers/usb/serial/keyspan.c:		if (this_urb->status == -EINPROGRESS) {
drivers/usb/serial/keyspan.c:	} while (urb->status != -EINPROGRESS);
drivers/usb/serial/keyspan.c:		if (this_urb->status != -EINPROGRESS)
drivers/usb/serial/keyspan.c:			if (this_urb->status != -EINPROGRESS)
drivers/usb/serial/keyspan.c:	if (urb && urb->status == -EINPROGRESS)
drivers/usb/serial/keyspan.c:	/*while (p_priv->outcont_urb->status == -EINPROGRESS) {
drivers/usb/serial/keyspan.c:	if (this_urb->status == -EINPROGRESS) {
drivers/usb/serial/keyspan.c:	if (this_urb->status == -EINPROGRESS) {
drivers/usb/serial/keyspan.c:	if (this_urb->status == -EINPROGRESS) {
drivers/usb/serial/keyspan.c:	if (this_urb->status == -EINPROGRESS) {
drivers/usb/serial/keyspan.c:	if (this_urb->status == -EINPROGRESS) {
drivers/usb/serial/keyspan_pda.c: *	  urb status is -EINPROGRESS, meaning it cannot write at the moment
drivers/usb/serial/keyspan_pda.c:	   again (the only sudden transition was the one from EINPROGRESS to
drivers/usb/serial/kl5kusb105.c:			if (priv->write_urb_pool[i]->status != -EINPROGRESS) {
drivers/usb/serial/kl5kusb105.c:		if (priv->write_urb_pool[i]->status == -EINPROGRESS) {
drivers/usb/serial/kl5kusb105.c:		if (priv->write_urb_pool[i]->status != -EINPROGRESS) {
drivers/usb/serial/mos7720.c:	if (port->read_urb->status != -EINPROGRESS) {
drivers/usb/serial/mos7720.c:		if (mos7720_port->write_urb_pool[i] && mos7720_port->write_urb_pool[i]->status == -EINPROGRESS)
drivers/usb/serial/mos7720.c:		if (mos7720_port->write_urb_pool[i] && mos7720_port->write_urb_pool[i]->status != -EINPROGRESS)
drivers/usb/serial/mos7720.c:		if (mos7720_port->write_urb_pool[i] && mos7720_port->write_urb_pool[i]->status != -EINPROGRESS) {
drivers/usb/serial/mos7720.c:	if (port->read_urb->status != -EINPROGRESS) {
drivers/usb/serial/mos7720.c:	if(port->read_urb->status != -EINPROGRESS) {
drivers/usb/serial/mos7840.c:	if (mos7840_port->read_urb->status != -EINPROGRESS) {
drivers/usb/serial/mos7840.c:	if (mos7840_port->read_urb->status != -EINPROGRESS) {
drivers/usb/serial/sierra.c:		if (this_urb->status == -EINPROGRESS) {
drivers/usb/serial/sierra.c:		if (this_urb && this_urb->status != -EINPROGRESS)
drivers/usb/serial/sierra.c:		if (this_urb && this_urb->status == -EINPROGRESS)
drivers/usb/misc/adutux.c:				if (dev->interrupt_in_urb->status == -EINPROGRESS) {
drivers/usb/misc/adutux.c:	if (should_submit && !dev->interrupt_in_urb->status==-EINPROGRESS) {
drivers/usb/misc/adutux.c:		if (dev->interrupt_out_urb->status == -EINPROGRESS) {
drivers/usb/misc/auerswald.c:        urb->status    = -EINPROGRESS;    /* usb_submit_urb does this, too */
drivers/usb/misc/auerswald.c:   the result is 0 if the urb is cancelled, or -EINPROGRESS if
drivers/usb/misc/auerswald.c:		if (urb->status != -EINPROGRESS) {	/* No callback?!! */
drivers/usb/misc/auerswald.c:-EINPROGRESS	during submission until end
drivers/usb/misc/usbtest.c:				case -EINPROGRESS:
drivers/usb/misc/usbtest.c:	if (!(retval == 0 || retval == -EINPROGRESS)) {

Alan Stern

