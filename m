Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZFIPBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZFIPBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 11:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbZFIPBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 11:01:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53998 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751885AbZFIPBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 11:01:16 -0400
Date: Tue, 9 Jun 2009 16:01:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Oskar Schirmer" <os@emlix.com>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-kernel@vger.kernel.org,
       Fabian Godehardt <fg@emlix.com>, Oskar Schirmer <os@emlix.com>
Subject: Re: [PATCH 8/8] imx: serial: add IrDA support to serial driver
Message-ID: <20090609160132.31265ffc@lxorguk.ukuu.org.uk>
In-Reply-To: <1244555211-15618-9-git-send-email-os@emlix.com>
References: <1244555211-15618-1-git-send-email-os@emlix.com>
	<1244555211-15618-2-git-send-email-os@emlix.com>
	<1244555211-15618-3-git-send-email-os@emlix.com>
	<1244555211-15618-4-git-send-email-os@emlix.com>
	<1244555211-15618-5-git-send-email-os@emlix.com>
	<1244555211-15618-6-git-send-email-os@emlix.com>
	<1244555211-15618-7-git-send-email-os@emlix.com>
	<1244555211-15618-8-git-send-email-os@emlix.com>
	<1244555211-15618-9-git-send-email-os@emlix.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef CONFIG_IRDA
> +#define USE_IRDA(sport)	((sport)->use_irda)
> +#else
> +#define USE_IRDA(sport)	(0)
> +#endif
> +

You define this but only use it in about half the cases ?

> +#ifdef CONFIG_IRDA
> +	if (sport->use_irda) {
> +		/* half duplex - wait for end of transmission */
> +		int n = 256;

Otherwise this series looks sound.

While you are fiddling with the baud rate the driver really should work
out the resulting actual baud rate and call

	tty_encode_baud_rate(tty, in-rate, out-rate);

that will report back the resulting rate and knows how to encode all the
termios fields as well as reporting close values to the requested speed
as the speed requested (eg if you ask for B38400 and it tries to encode
38215 or similar it will encode back B38400)

Alan
