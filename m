Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbZIQDq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbZIQDq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759786AbZIQDq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:46:26 -0400
Received: from netrider.rowland.org ([192.131.102.5]:53259 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758458AbZIQDqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:46:25 -0400
Date: Wed, 16 Sep 2009 23:46:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] usb console,usb-serial: pass initial console baud
 on to first tty open
In-Reply-To: <4AB1AF91.2080606@windriver.com>
Message-ID: <Pine.LNX.4.44L0.0909162344350.24376-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, Jason Wessel wrote:

> Alan Stern wrote:
> > On Wed, 16 Sep 2009, Jason Wessel wrote:
> >
> >   
> >> The first open of the usb serial HW has the termios initialized to the
> >> default of 9600 baud, and this will override what ever was setup via
> >> the original console initialization.
> >>     
> >
> > I don't understand.  The first open of the console hardware occurs in 
> > console.c as part of usb_console_setup(), and it uses the baud rate 
> > passed in via the console options.  Why does anything need to get 
> > saved?
> >   
> 
> The initialization in console.c is done with a dummy tty structure that
> is thrown away.  It is thrown away because it was not connected to any
> device handle.
> 
> Any new tty that is opened defaults to 9600 baud, for the mct_u232
> driver as an example, if you boot the system with
> console=ttyUSB0,115200, when mingetty starts it will inherit 9600 from
> the first tty that is opened, vs reading the value from the HW.  Even if
> you have a pl2303 and boot with the 115200 baud, you can run "stty -a <
> /dev/ttyUSB0" and you will see it reports it is running at 9600.  The
> pl2303 driver just happens to work because it handles the baud differently.
> 
> I elected to save the baud because:
> 
> 1) There was no uniform interface to read the current baud from the usb
> hardware
> 
> 2) There was no documented API for getting tty to attach when you create
> the initial console.
> 
> If there is a better way to fix this, it would be good to continue the
> discussion.

I guess a better approach would be not to throw away the "dummy" tty 
structure, thereby keeping the termios structure as well.  But I don't 
know if this is practical.

How do other serial console drivers handle this?

Alan Stern

