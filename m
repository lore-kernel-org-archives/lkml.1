Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab0CHUCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:02:12 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46085 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755253Ab0CHUCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:02:08 -0500
Date: Mon, 8 Mar 2010 15:02:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@linux.intel.com>, Oliver Neukum <oliver@neukum.org>,
       Andrew Morton <akpm@linux-foundation.org>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb-serial: Fix usb serial console open/close regression
In-Reply-To: <4B9546F6.6070901@windriver.com>
Message-ID: <Pine.LNX.4.44L0.1003081459490.1596-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010, Jason Wessel wrote:

> Alan, are you thinking about something like the patch one listed below?
> 
> That led me to wonder if we additionally want to remove the ->console
> semi-private variable from the usb-serial port struct. I tested that
> and included a patch here as well as an RFC.
> 
> If we come to agreement I'll send new patches with appropriate
> patch headers.

> ----- PART TWO STARTS HERE -----
> 
> Remove the console variable from the usb serial private data.
> 

> --- a/drivers/usb/serial/console.c
> +++ b/drivers/usb/serial/console.c
> @@ -180,7 +180,6 @@ static int usb_console_setup(struct cons
>  	--port->port.count;
>  	/* The console is special in terms of closing the device so
>  	 * indicate this port is now acting as a system console. */
> -	port->console = 1;
>  	set_bit(ASYNCB_CONSOLE, &port->port.flags);
>  
>  	mutex_unlock(&serial->disc_mutex);
> @@ -217,7 +216,7 @@ static void usb_console_write(struct con
>  
>  	dbg("%s - port %d, %d byte(s)", __func__, port->number, count);
>  
> -	if (!port->console) {
> +	if (!test_bit(ASYNCB_INITIALIZED, &port->port.flags)) {

Here and below you wrote INITIALIZED instead of CONSOLE.

Alan Stern

