Return-Path: <linux-kernel-owner+w=401wt.eu-S1760602AbYDZXHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760602AbYDZXHg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 19:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbYDZXHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 19:07:19 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:59377 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbYDZXHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 19:07:18 -0400
Message-ID: <4813B5AB.4060308@keyaccess.nl>
Date: Sun, 27 Apr 2008 01:07:23 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 50/54] ISAPNP: fold isapnp_read_resources() back into
 isapnp_get_resources()
References: <20080425183807.366134771@ldl.fc.hp.com> <20080425183934.516655076@ldl.fc.hp.com>
In-Reply-To: <20080425183934.516655076@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-04-08 20:38, Bjorn Helgaas wrote:

> +	for (i = 0; i < ISAPNP_MAX_MEM; i++) {
> +		ret = isapnp_read_word(ISAPNP_CFG_MEM + (i << 3)) << 8;
> +		if (!ret)
> +			continue;
> +		pnp_res = pnp_add_mem_resource(dev, ret, ret, 0);
> +		if (pnp_res)
> +			pnp_res->index = i;
> +	}
> +	for (i = 0; i < ISAPNP_MAX_IRQ; i++) {
> +		ret = (isapnp_read_word(ISAPNP_CFG_IRQ + (i << 1)) >>
> +		     8);

Truly trivial, but if you kill the useless outer (), it fits on one line...

Rene
