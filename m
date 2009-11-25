Return-Path: <linux-kernel-owner+w=401wt.eu-S1759868AbZKYWnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868AbZKYWnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 17:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759848AbZKYWno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 17:43:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759846AbZKYWno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 17:43:44 -0500
Date: Wed, 25 Nov 2009 14:43:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: cliffcai.sh@gmail.com, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, cliff.cai@analog.com,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH v4][mmc/host]:Blackfin SD Host Controller Driver
Message-Id: <20091125144307.5e7d6d6f.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0911251425q178993fete79b675e2730bdec@mail.gmail.com>
References: <1259162390-378-1-git-send-email-cliffcai.sh@gmail.com>
	<20091125140422.cdee4a0d.akpm@linux-foundation.org>
	<8bd0f97a0911251425q178993fete79b675e2730bdec@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009 17:25:20 -0500
Mike Frysinger <vapier.adi@gmail.com> wrote:

> >> +static void sdh_start_cmd(struct sdh_host *host, struct mmc_command *cmd)
> >> +{
> >> + __ __ unsigned int sdh_cmd;
> >> + __ __ unsigned int stat_mask;
> >> +
> >> + __ __ dev_dbg(mmc_dev(host->mmc), "%s enter cmd: 0x%p\n", __func__, cmd);
> >> + __ __ WARN_ON(host->cmd != NULL);
> >> + __ __ host->cmd = cmd;
> >> +
> >> + __ __ sdh_cmd = 0;
> >> + __ __ stat_mask = 0;
> >> +
> >> + __ __ sdh_cmd |= cmd->opcode;
> >> +
> >> + __ __ if (cmd->flags & MMC_RSP_PRESENT) {
> >> + __ __ __ __ __ __ sdh_cmd |= CMD_RSP;
> >> + __ __ __ __ __ __ stat_mask |= CMD_RESP_END;
> >> + __ __ } else
> >> + __ __ __ __ __ __ stat_mask |= CMD_SENT;

(ftso gmail)

> > Arguably wrong from a coding-style POV and looks weird IMO. __Adds a bit
> > of risk that subsequent coders will think they're writing in python adn
> > will add bugs.
> 
> i dont really get what you're referring to here.  the code in question
> looks ifne to me, and i dont see anything "python-esque" about it

Code like

	if (expr) {
		line1;
		line2;
	} else
		line3;

looks odd and can cause people to later add bugs along the lines of

	if (expr) {
		line1;
		line2;
	} else
+		line3a;
		line3;

this is particularly the case if line3 is long, or is preceded by a
comment.  This has happened in the past.

Adding the missing braces reduces the risk that this will occur.
