Return-Path: <linux-kernel-owner+w=401wt.eu-S1751443AbXCSOc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbXCSOc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 10:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbXCSOc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 10:32:26 -0400
Received: from inetc.connecttech.com ([64.7.140.42]:3372 "EHLO
	inetc.connecttech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbXCSOcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 10:32:25 -0400
From: "Stuart MacDonald" <stuartm@connecttech.com>
To: "'Richard Knutsson'" <ricknu-0@student.ltu.se>,
       "'Andrew Morton'" <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>
Subject: RE: [PATCH] usb/serial/whiteheat: Convert to generic boolean
Date: Mon, 19 Mar 2007 10:31:26 -0400
Organization: Connect Tech Inc.
Message-ID: <001101c76a33$4729b320$294b82ce@stuartm>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <20070317003342.14847.72517.sendpatchset@thinktank.campus.ltu.se>
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Knutsson [mailto:ricknu-0@student.ltu.se] 

Okay by me. Thanks Richard.

Signed-off-by: Stuart MacDonald <stuartm@connecttech.com>

..Stu

> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> ---
> Compile-tested with "allyes", "allmod" & "allno" on i386
> 
> 
> diff --git a/drivers/usb/serial/whiteheat.c 
> b/drivers/usb/serial/whiteheat.c
> index bf16e9e..27c5f8f 100644
> --- a/drivers/usb/serial/whiteheat.c
> +++ b/drivers/usb/serial/whiteheat.c
> @@ -1109,7 +1109,7 @@ static int firm_send_command (struct 
> usb_serial_port *port, __u8 command, __u8 *
>  	command_port = port->serial->port[COMMAND_PORT];
>  	command_info = usb_get_serial_port_data(command_port);
>  	spin_lock_irqsave(&command_info->lock, flags);
> -	command_info->command_finished = FALSE;
> +	command_info->command_finished = false;
>  	
>  	transfer_buffer = (__u8 
> *)command_port->write_urb->transfer_buffer;
>  	transfer_buffer[0] = command;
> @@ -1124,12 +1124,12 @@ static int firm_send_command (struct 
> usb_serial_port *port, __u8 command, __u8 *
>  	spin_unlock_irqrestore(&command_info->lock, flags);
>  
>  	/* wait for the command to complete */
> -	wait_event_interruptible_timeout(command_info->wait_command, 
> -		(command_info->command_finished != FALSE), 
> COMMAND_TIMEOUT);
> +	wait_event_interruptible_timeout(command_info->wait_command,
> +		(bool)command_info->command_finished, COMMAND_TIMEOUT);
>  
>  	spin_lock_irqsave(&command_info->lock, flags);
>  
> -	if (command_info->command_finished == FALSE) {
> +	if (command_info->command_finished == false) {
>  		dbg("%s - command timed out.", __FUNCTION__);
>  		retval = -ETIMEDOUT;
>  		goto exit;
> diff --git a/drivers/usb/serial/whiteheat.h 
> b/drivers/usb/serial/whiteheat.h
> index d714eff..f160797 100644
> --- a/drivers/usb/serial/whiteheat.h
> +++ b/drivers/usb/serial/whiteheat.h
> @@ -20,10 +20,6 @@
>  #define __LINUX_USB_SERIAL_WHITEHEAT_H
>  
>  
> -#define FALSE	0
> -#define TRUE	1
> -
> -
>  /* WhiteHEAT commands */
>  #define WHITEHEAT_OPEN			1	/* open 
> the port */
>  #define WHITEHEAT_CLOSE			2	/* 
> close the port */
> 

