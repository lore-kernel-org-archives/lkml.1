Return-Path: <linux-kernel-owner+w=401wt.eu-S1758255AbZADLGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbZADLGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbZADLGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:06:14 -0500
Received: from vuizook.err.no ([85.19.221.46]:52956 "EHLO vuizook.err.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261AbZADLGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:06:12 -0500
From: Tollef Fog Heen <tfheen@err.no>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, werner@cornelius-consult.de,
       frank@kingswood-consulting.co.uk
Subject: Re: [PATCH] Winchiphead 340/1: full baud rate and status/control line support
References: <200807290254.m6T2sIBG010575@imap1.linux-foundation.org>
	<20080729104331.367fde6b@lxorguk.ukuu.org.uk>
	<87ej3d4zv3.fsf_-_@xoog.err.no>
	<20080921151407.10c89452@lxorguk.ukuu.org.uk>
Mail-Copies-To: never
Date: Sun, 04 Jan 2009 11:19:21 +0100
In-Reply-To: <20080921151407.10c89452@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Sun, 21 Sep 2008 15:14:07 +0100")
Message-ID: <87sknzs79y.fsf@qurzaw.linpro.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

]] Alan Cox 

| Some niggles but this is a big improvement to the code.

Thanks.  New patch incoming RSN.

| >  static int ch341_set_baudrate(struct usb_device *dev,
| > +			      struct tty_struct *tty,
| >  			      struct ch341_private *priv)
| > +	baud = CH341_BAUDBASE_FACTOR / t1;
| > +
| > +	if (baud && tty)
| > +		tty_encode_baud_rate(tty, baud, baud);
| 
| Can you really get a speed below 1 baud ?

Unsure what you mean here?  Why would you ever end up with baudrates
below 1?

| > +	control = priv->line_control;
| > +	spin_unlock_irqrestore(&priv->lock, flags);
| > +
| > +	return ch341_set_handshake(port->serial->dev, control);
| > +}
| 
| This could race another set_handshake ? I'm not sure it matters and I'd
| suggest that stuff gets fixed after this is submitted separately

What's the easiest way to fix this?

-- 
Tollef Fog Heen
UNIX is user friendly, it's just picky about who its friends are
