Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYJLI6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYJLI6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 04:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYJLI6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 04:58:45 -0400
Received: from server.drzeus.cx ([85.8.24.28]:43674 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751437AbYJLI6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 04:58:45 -0400
Date: Sun, 12 Oct 2008 10:58:42 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch 2/5] s3cmci: cpufreq support
Message-ID: <20081012105842.2c327627@mjolnir.drzeus.cx>
In-Reply-To: <20081010103314.435915526@fluff.org.uk>
References: <20081010103221.551485781@fluff.org.uk>
	<20081010103314.435915526@fluff.org.uk>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008 11:32:23 +0100
Ben Dooks <ben-linux@fluff.org> wrote:

> +	host = container_of(nb, struct s3cmci_host, freq_transition);
> +	newclk = clk_get_rate(host->clk);
> +	mmc = host->mmc;
> +
> +	if ((val == CPUFREQ_PRECHANGE && host->clk_rate > newclk) ||
> +	    (val == CPUFREQ_POSTCHANGE && host->clk_rate < newclk)) {

Isn't this backwards? The goal should be to avoid overclocking the
card, so if the old clock (which I assume is clk_rate) is slower than
the new clock (newclk), then we should adjust before the change happens,
temporarily underclocking the card.

(and vice versa for when the old clock is faster than the new clock)

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
