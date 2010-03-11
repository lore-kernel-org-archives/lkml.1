Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365Ab0CKRCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:02:50 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:39529 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933341Ab0CKRCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:02:49 -0500
Date: Thu, 11 Mar 2010 18:02:48 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: Race condition in TTY ldisc layer in 2.6.33
Message-ID: <20100311170248.GA2482@rere.qmqm.pl>
References: <20100311133222.GA19884@rere.qmqm.pl> <20100311135009.GA8801@kroah.com> <20100311155015.GA25607@rere.qmqm.pl> <20100311160653.GA30832@rere.qmqm.pl> <20100311162930.GA18217@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100311162930.GA18217@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 05:29:30PM +0100, Johan Hovold wrote:
> On Thu, Mar 11, 2010 at 05:06:53PM +0100, Micha³ Miros³aw wrote:
> > On Thu, Mar 11, 2010 at 04:50:15PM +0100, Micha³ Miros³aw wrote:
> > > On Thu, Mar 11, 2010 at 05:50:09AM -0800, Greg KH wrote:
> > > > On Thu, Mar 11, 2010 at 02:32:22PM +0100, Micha? Miros?aw wrote:
> > > > > Looks like there's some race contition in switching ldiscs on USB serial
> > > > > ports. The following warnings trigger sometimes after killing and restarting
> > > > > process that changes ldisc and waits forever. In case you want to look at
> > > > > the code, there it is: http://rere.qmqm.pl/~mirq/sermmc/
> > > > If you apply git commit 638b9648ab51c9c549ff5735d3de519ef6199df3 to the
> > > > 2.6.33 kernel, does it solve the issue for you?
> > > I'm running with the patch now. After couple cycles of starting and killing
> > > the ldisc-setting process I get no warnings. I'll get back to you when/if
> > > I encounter them again.
> > Hah. Just seconds after I sent that mail I hit this again. The stack traces
> > are exactly the same (except for different starting address of
> > flush_to_ldisc()).
> > 
> > The warnings are triggered by:
> > 
> > 	struct usb_serial_port *port = tty->driver_data;
> > 	...
> > 	/* count is managed under the mutex lock for the tty so cannot
> > 	   drop to zero until after the last close completes */
> > 	WARN_ON(!port->port.count);
> This is a false warning that was fixed by commit
> 49d3380e3f1297ff7bdc700c0a7fe6c3a036b3ab.

Removing the WARN_ON()s will definitely keep them from triggering. ;)

> > BTW, Couple of minutes earlier I got this message:
> > [  201.629616] cp210x ttyUSB0: usb_serial_generic_resubmit_read_urb - failed resubmitting read urb, error -1
> > But after that I disconnected and reconnected the device, so this is probably
> > not relevant here.
> You're right, it's unrelated. I submitted a patch a while ago that
> removes this message (as it is not an error):
> http://thread.gmane.org/gmane.linux.usb.general/28047/focus=28052

I'll apply it then, if that's the case.

Thanks for your help.

Best Regards,
Micha³ Miros³aw
