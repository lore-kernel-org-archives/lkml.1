Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229Ab0CKQVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 11:21:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:50750 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933204Ab0CKQVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 11:21:12 -0500
Date: Thu, 11 Mar 2010 11:21:11 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
cc: Greg KH <greg@kroah.com>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: Race condition in TTY ldisc layer in 2.6.33
In-Reply-To: <20100311160653.GA30832@rere.qmqm.pl>
Message-ID: <Pine.LNX.4.44L0.1003111118360.1367-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010, [iso-8859-2] Micha³ Miros³aw wrote:

> On Thu, Mar 11, 2010 at 04:50:15PM +0100, Micha³ Miros³aw wrote:
> > On Thu, Mar 11, 2010 at 05:50:09AM -0800, Greg KH wrote:
> > > On Thu, Mar 11, 2010 at 02:32:22PM +0100, Micha? Miros?aw wrote:
> > > > Looks like there's some race contition in switching ldiscs on USB serial
> > > > ports. The following warnings trigger sometimes after killing and restarting
> > > > process that changes ldisc and waits forever. In case you want to look at
> > > > the code, there it is: http://rere.qmqm.pl/~mirq/sermmc/
> > > If you apply git commit 638b9648ab51c9c549ff5735d3de519ef6199df3 to the
> > > 2.6.33 kernel, does it solve the issue for you?
> > I'm running with the patch now. After couple cycles of starting and killing
> > the ldisc-setting process I get no warnings. I'll get back to you when/if
> > I encounter them again.
> 
> Hah. Just seconds after I sent that mail I hit this again. The stack traces
> are exactly the same (except for different starting address of
> flush_to_ldisc()).
> 
> The warnings are triggered by:
> 
> 	struct usb_serial_port *port = tty->driver_data;
> 	...
> 	/* count is managed under the mutex lock for the tty so cannot
> 	   drop to zero until after the last close completes */
> 	WARN_ON(!port->port.count);
> 
> BTW, Couple of minutes earlier I got this message:
> 
> [  201.629616] cp210x ttyUSB0: usb_serial_generic_resubmit_read_urb - failed resubmitting read urb, error -1
> 
> But after that I disconnected and reconnected the device, so this is probably
> not relevant here.

It looks like Greg gave you the wrong commit ID.  You should use this
one: 49d3380e3f1297ff7bdc700c0a7fe6c3a036b3ab.  It removes those
WARN_ON statements entirely.

Actually, you should use both commits.

Alan Stern

