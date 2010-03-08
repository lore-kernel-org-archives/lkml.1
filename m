Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0CHQIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 11:08:00 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41312 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755360Ab0CHQH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:07:58 -0500
Date: Mon, 8 Mar 2010 11:07:56 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       Oliver Neukum <oliver@neukum.org>,
       Andrew Morton <akpm@linux-foundation.org>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb-serial: Fix usb serial console open/close regression
In-Reply-To: <4B951B0E.3000801@windriver.com>
Message-ID: <Pine.LNX.4.44L0.1003081105240.1596-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010, Jason Wessel wrote:

> > This is a little unfortunate.  It would be better to prevent
> > tty_port_shutdown() from clearing ASYNCB_INITIALIZED in the first
> > place.  The problem is that the tty core doesn't know when the port is
> > being used as a console.  There ought to be a way to tell it.
> >   
> 
> I agree, but presently there is no way to do so.   Up until 2.6.33 the
> ASYNCB_INITIALIZED was being used to track this, but now it is used a
> bit differently.
> 
> We still also have the same sort of issue for the passing in the initial
> baud.  I don't know if you want to go for a short term approach this
> way, or try to implement something different right now.  When you do
> consider something longer term, I would like it to incorporate the other
> serial settings as well, such that if the console initializes them first
> the get correctly inherited by the tty open().

I don't want to make any changes before hearing from Alan Cox.  Doing 
the right thing probably means switching all the tty drivers over to 
the tty_port model.  I don't know which ones still need to be changed.

Alan Stern

