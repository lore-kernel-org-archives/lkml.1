Return-Path: <linux-kernel-owner+w=401wt.eu-S1750741AbXCLSsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750741AbXCLSsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbXCLSsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:48:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbXCLSsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:48:21 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Mark Lord <lkml@rtr.ca>
Subject: Re: [BUG} usb-serial regression in 2.6.21-rc2-git3
Date: Mon, 12 Mar 2007 19:48:19 +0100
User-Agent: KMail/1.9.1
Cc: Greg KH <greg@kroah.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45F57F63.7010308@rtr.ca> <45F584D9.4090802@rtr.ca>
In-Reply-To: <45F584D9.4090802@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703121948.21453.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. März 2007 17:50 schrieb Mark Lord:
> Mark Lord wrote:
> >
> > Okay, from that part (above), the problem is obvious:
> > in that the "MCT U232 converter now disconnected" appears,
> > and then we continue to try and call the driver's method.. Oops!
> > 
> > The hack patch below "fixes" this, but it really just hides whatever
> > the real problem underneath was:

static void destroy_serial(struct kref *kref):

	/* the ports are cleaned up and released in port_release() */
	for (i = 0; i < serial->num_ports; ++i)
		if (serial->port[i]->dev.parent != NULL) {
			device_unregister(&serial->port[i]->dev);
			serial->port[i] = NULL;
		}

	if (serial->type->shutdown)
		serial->type->shutdown(serial);

IMHO shutdown() is using serial->port[] and bombs.
Could you reverse the order here?

	Regards
		Oliver
