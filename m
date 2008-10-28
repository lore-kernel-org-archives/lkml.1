Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbYJ1CHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbYJ1CHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 22:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYJ1CHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 22:07:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:33902 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbYJ1CHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 22:07:09 -0400
Message-ID: <490673AB.2090502@kernel.org>
Date: Tue, 28 Oct 2008 11:06:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 2.6.28-rc2] sata_promise: proper hardreset
References: <200810270049.m9R0ngI8027933@harpo.it.uu.se>
In-Reply-To: <200810270049.m9R0ngI8027933@harpo.it.uu.se>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 28 Oct 2008 02:06:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mikael.

Mikael Pettersson wrote:
> +static int pdc_pata_hardreset(struct ata_link *link, unsigned int *class,
> +			      unsigned long deadline)
> +{
> +	pdc_reset_port(link->ap);
> +	return 0;
> +}

You either need to return -EAGAIN here to ask for follow-up SRST or
override softreset.  I think pdc_reset_port() doesn't actually reset the
ATA channel, right?  In that case, the latter would be the correct thing
to do.

Thanks.

-- 
tejun
