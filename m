Return-Path: <linux-kernel-owner+w=401wt.eu-S1760043AbZIQDkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbZIQDkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759923AbZIQDkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:40:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:58568 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758440AbZIQDkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:40:02 -0400
Message-ID: <4AB1AF91.2080606@windriver.com>
Date: Wed, 16 Sep 2009 22:40:01 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] usb console,usb-serial: pass initial console baud
 on to first tty open
References: <Pine.LNX.4.44L0.0909162331160.24041-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0909162331160.24041-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2009 03:40:01.0498 (UTC) FILETIME=[89593BA0:01CA3748]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Wed, 16 Sep 2009, Jason Wessel wrote:
>
>   
>> The first open of the usb serial HW has the termios initialized to the
>> default of 9600 baud, and this will override what ever was setup via
>> the original console initialization.
>>     
>
> I don't understand.  The first open of the console hardware occurs in 
> console.c as part of usb_console_setup(), and it uses the baud rate 
> passed in via the console options.  Why does anything need to get 
> saved?
>   

The initialization in console.c is done with a dummy tty structure that
is thrown away.  It is thrown away because it was not connected to any
device handle.

Any new tty that is opened defaults to 9600 baud, for the mct_u232
driver as an example, if you boot the system with
console=ttyUSB0,115200, when mingetty starts it will inherit 9600 from
the first tty that is opened, vs reading the value from the HW.  Even if
you have a pl2303 and boot with the 115200 baud, you can run "stty -a <
/dev/ttyUSB0" and you will see it reports it is running at 9600.  The
pl2303 driver just happens to work because it handles the baud differently.

I elected to save the baud because:

1) There was no uniform interface to read the current baud from the usb
hardware

2) There was no documented API for getting tty to attach when you create
the initial console.

If there is a better way to fix this, it would be good to continue the
discussion.

Thanks,
Jason.

