Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab0CAIEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:04:09 -0500
Received: from symlink.to.noone.org ([85.10.207.172]:58680 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab0CAIEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:04:05 -0500
Date: Mon, 1 Mar 2010 09:04:02 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Dan Carpenter <error27@gmail.com>, linux-serial@vger.kernel.org,
       nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 2/2] serial: Add driver for the Altera UART
Message-ID: <20100301080402.GD32296@distanz.ch>
References: <1267108523-32767-1-git-send-email-tklauser@distanz.ch> <1267109261-752-1-git-send-email-tklauser@distanz.ch> <20100226195022.GF8417@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100226195022.GF8417@bicker>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-02-26 at 20:50:22 +0100, Dan Carpenter <error27@gmail.com> wrote:
> A couple smatch complaints.
> 
> drivers/serial/altera_jtaguart.c
>    380          if (co->index >= 0 && co->index <= ALTERA_JTAGUART_MAXPORTS)
>    381                  co->index = 0;
>    382          port = &altera_jtaguart_ports[co->index].port;
> 
> This test seems backward.  co->index == -1 would be a buffer underflow.
> 
> drivers/serial/altera_uart.c
>    455          if ((co->index >= 0)
>    456              && (co->index <= CONFIG_SERIAL_ALTERA_UART_MAXPORTS))
>    457                  co->index = 0;
>    458          port = &altera_uart_ports[co->index].port;
> 
> Same here.

Yep, those look completely wrong. I'll post an updated patch (including
the other changes suggested by Alan and Peter) later on.

Thanks,
Tobias
