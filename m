Return-Path: <linux-kernel-owner+w=401wt.eu-S932673AbZHNPvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbZHNPvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 11:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932603AbZHNPvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 11:51:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:56174 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184AbZHNPvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 11:51:22 -0400
Date: Fri, 14 Aug 2009 08:50:04 -0700
From: Greg KH <gregkh@suse.de>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] icom: bit and/or confusion?
Message-ID: <20090814155004.GA10977@suse.de>
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

This change is the exact same thing, right?  How is the original
incorrect here?

thanks,

greg k-h
