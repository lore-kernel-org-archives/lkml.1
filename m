Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965943Ab0BZT6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 14:58:50 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:40331 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965902Ab0BZT6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 14:58:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=CcymVnSW+HSXg3aM/DH/osnLNps8SL0cAULAyTZiumsLKKNyF9t+C8VhJecI5//3hQ
         KsnabDKxTu7CvhhWGCb4oGfUdpN5IInXSXfUtM6GNcI9Y+AmpsQENgA5+Ol0UQ9VCsPL
         YTiB0utXt2655UUloQ1rmMUTO+4DFc3uWY6mE=
Date: Fri, 26 Feb 2010 22:50:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: linux-serial@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 2/2] serial: Add driver for the Altera UART
Message-ID: <20100226195022.GF8417@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Tobias Klauser <tklauser@distanz.ch>, linux-serial@vger.kernel.org,
	nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org
References: <1267108523-32767-1-git-send-email-tklauser@distanz.ch> <1267109261-752-1-git-send-email-tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267109261-752-1-git-send-email-tklauser@distanz.ch>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple smatch complaints.

drivers/serial/altera_jtaguart.c
   380          if (co->index >= 0 && co->index <= ALTERA_JTAGUART_MAXPORTS)
   381                  co->index = 0;
   382          port = &altera_jtaguart_ports[co->index].port;

This test seems backward.  co->index == -1 would be a buffer underflow.

drivers/serial/altera_uart.c
   455          if ((co->index >= 0)
   456              && (co->index <= CONFIG_SERIAL_ALTERA_UART_MAXPORTS))
   457                  co->index = 0;
   458          port = &altera_uart_ports[co->index].port;

Same here.

regards,
dan carpenter
