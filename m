Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933Ab0AUNeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab0AUNeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030Ab0AUNeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:34:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49207 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab0AUNeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:34:15 -0500
Date: Thu, 21 Jan 2010 14:34:07 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Roel Kluin <roel.kluin@gmail.com>,
       Alan Cox <alan@linux.intel.com>, Fabian Godehardt <fg@emlix.com>,
       Daniel =?iso-8859-15?Q?Gl=F6ckner?= <dg@emlix.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/8] serial: imx: bit &/| confusion
Message-ID: <20100121133407.GO7200@pengutronix.de>
References: <20100120234759.GC32068@kroah.com> <1264031403-32239-6-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1264031403-32239-6-git-send-email-gregkh@suse.de>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 14:33:29 up 101 days,  2:22, 65 users,  load average: 6.43, 6.74,
	4.51
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 03:50:01PM -0800, Greg Kroah-Hartman wrote:
> From: Roel Kluin <roel.kluin@gmail.com>
> 
> Since UCR1_UARTEN is defined 1, the port was always treated as enabled.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> Cc: Alan Cox <alan@linux.intel.com>
> Acked-by: Oskar Schirmer <os@emlix.com>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Fabian Godehardt <fg@emlix.com>
> Cc: Daniel Glöckner <dg@emlix.com>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
>  drivers/serial/imx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
> index 18130f1..60d665a 100644
> --- a/drivers/serial/imx.c
> +++ b/drivers/serial/imx.c
> @@ -1088,7 +1088,7 @@ imx_console_get_options(struct imx_port *sport, int *baud,
>  			   int *parity, int *bits)
>  {
>  
> -	if ( readl(sport->port.membase + UCR1) | UCR1_UARTEN ) {
> +	if (readl(sport->port.membase + UCR1) & UCR1_UARTEN) {
>  		/* ok, the port was enabled */
>  		unsigned int ucr2, ubir,ubmr, uartclk;
>  		unsigned int baud_raw;
> -- 
> 1.6.5.7
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
