Return-Path: <linux-kernel-owner+w=401wt.eu-S1030316AbXCMNue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030316AbXCMNue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 09:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030301AbXCMNue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 09:50:34 -0400
Received: from ns.suse.de ([195.135.220.2]:38097 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030298AbXCMNud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 09:50:33 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH] usb-serial regression fix
Date: Tue, 13 Mar 2007 14:50:23 +0100
User-Agent: KMail/1.9.1
Cc: Jim Radford <radford@blackbean.org>, Greg KH <greg@kroah.com>,
       linux-usb-devel@lists.sourceforge.net, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <45F57F63.7010308@rtr.ca> <200703131114.48068.oneukum@suse.de> <45F6A99A.8060008@rtr.ca>
In-Reply-To: <45F6A99A.8060008@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703131450.24462.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 13. März 2007 14:39 schrieb Mark Lord:
> Oliver Neukum wrote:
> >
> > If we get to destroy_serial(), how can ports still be open?
> 
> (1) open up a ckermit session on /dev/usb_serial_port_0.
> (2) suspend the machine (to RAM).
> (3) the suspend logic "removes" all USB devices.

No,

any open port has taken a reference in serial_open():
	serial = usb_serial_get_by_index(tty->index);

destroy_serial() can be called only when the refcount goes to zero. How
can there be open ports?

	Regards
		Oliver

