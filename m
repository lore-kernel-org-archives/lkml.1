Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbYDQG6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbYDQG6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 02:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYDQG6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 02:58:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:26567 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbYDQG6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 02:58:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=dhxAMCvZ0Ykgkxogee3ban2+XBBZJF2Vh/dkIZVN7nljzYif6fvDpJIEst30krpNcp/r4e8nqsn3HxS0hOPXeA+D6G2Hw+uyCA1eDE+CPEvEpLQfhpiZb89EVx54W8xUrtaJQrbljR5fL4SV5qlobkAIdsexBf8PUIXfs80qvmE=
Message-ID: <ed10ee420804162358k416bb443lf7c95892d84e75d2@mail.gmail.com>
Date: Wed, 16 Apr 2008 23:58:19 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Roel Kluin" <12o3l@tiscali.nl>
Subject: Re: [PATCH] mos7840: test and propagate set_uart_reg return value
Cc: "Greg KH" <greg@kroah.com>, linux-usb@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4806CF18.2050403@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4806CF18.2050403@tiscali.nl>
X-Google-Sender-Auth: 4c83e846af2e9c28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/08, Roel Kluin <12o3l@tiscali.nl> wrote:
> The test for an mos7840_set_uart_reg() error return value only works when
>  status is signed. propagate its error value.
>
>  Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>  ---
>
>  diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
>  index aeeb9cb..ef1ede2 100644
>  --- a/drivers/usb/serial/mos7840.c
>  +++ b/drivers/usb/serial/mos7840.c
>  @@ -1713,7 +1713,7 @@ static int mos7840_tiocmset(struct usb_serial_port *port, struct file *file,
>   {
>         struct moschip_port *mos7840_port;
>         unsigned int mcr;
>  -       unsigned int status;
>  +       int status;
>
>         dbg("%s - port %d", __FUNCTION__, port->number);
>
>  @@ -1739,11 +1739,10 @@ static int mos7840_tiocmset(struct usb_serial_port *port, struct file *file,
>
>         mos7840_port->shadowMCR = mcr;
>
>  -       status = 0;
>         status = mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER, mcr);
>         if (status < 0) {
>                 dbg("setting MODEM_CONTROL_REGISTER Failed\n");
>  -               return -1;
>  +               return status;
>         }
>
>         return 0;

O.K.  I can see you're changing types to properly match the function return
values.  May I ask why you didn't change mos7840_tiocmget the same way?

-sb
