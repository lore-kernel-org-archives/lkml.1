Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbYKDTHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbYKDTHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYKDTG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:06:58 -0500
Received: from kroah.org ([198.145.64.141]:49757 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753134AbYKDTG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:06:57 -0500
Date: Tue, 4 Nov 2008 09:55:42 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Fix close races in USB serial
Message-ID: <20081104175542.GA1328@kroah.com>
References: <20081104152916.30344.68193.stgit@localhost.localdomain> <20081104171128.GB630@kroah.com> <20081104173726.0271939d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104173726.0271939d@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 05:37:26PM +0000, Alan Cox wrote:
> > > -	if (port->port.count == (port->console? 1 : 0)) {
> > > +	if (port->port.count == (port->console ? 2 : 1)) {
> > 
> > Why are you testing for 2 here?
> 
> At the point we enter this routine port->port.count is the number of
> users of the port. If this is the final close then this is 1 (us), except
> if it is the USB console (in which case there will be two references).
> 
> The old code dropped the reference count first, the new code drops the
> kref and port->tty first, then shuts down the port and then drops the
> refcount. That avoids the race where we get the usb serial drivers trying
> to stuff bytes into a closed port and the ldisc layer in turn trying to
> echo them
> - which causes the warnings.

Ah, ok, that makes sense, thanks.

You might want to document that in there so that others understand it as
well.

thanks,

greg k-h
