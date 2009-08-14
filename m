Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZHNRMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZHNRMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 13:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbZHNRL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 13:11:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309AbZHNRL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 13:11:57 -0400
Date: Fri, 14 Aug 2009 10:10:30 -0700
From: Greg KH <gregkh@suse.de>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] icom: bit and/or confusion?
Message-ID: <20090814171030.GB21606@suse.de>
References: <4A85525A.9030601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A85525A.9030601@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 02:02:34PM +0200, Roel Kluin wrote:
> Previously, if any bit other than CMD_SND_BREAK was set, CMD_SND_BREAK
> was not unset.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> I think meant was: If CMD_SND_BREAK is set, unset it. Correct?
> 
> // vi drivers/serial/icom.h +137
> #define CMD_SND_BREAK                0x04
> 
> diff --git a/drivers/serial/icom.c b/drivers/serial/icom.c
> index cd1b6a4..060f4e3 100644
> --- a/drivers/serial/icom.c
> +++ b/drivers/serial/icom.c
> @@ -617,7 +617,7 @@ static void shutdown(struct icom_port *icom_port)
>  	 * disable break condition
>  	 */
>  	cmdReg = readb(&icom_port->dram->CmdReg);
> -	if ((cmdReg | CMD_SND_BREAK) == CMD_SND_BREAK) {
> +	if (cmdReg & CMD_SND_BREAK) {

Nevermind, Alan rightly pointed out that I was completly wrong, I'll go
queue this up.

thanks,

greg k-h
