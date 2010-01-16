Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab0APEUP (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 23:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617Ab0APEUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 23:20:14 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:10024 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0APEUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 23:20:12 -0500
Date: Fri, 15 Jan 2010 21:20:10 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 03/11] pci: reject mmio range start from 0 on
	pci_bridge read
Message-ID: <20100116042010.GD22215@ldl.fc.hp.com>
References: <1263609721-3921-1-git-send-email-yinghai@kernel.org> <1263609721-3921-4-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263609721-3921-4-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please change title of patch to:

	pci: pci_read_bridge_bases rejects MMIO ranges starting at 0

* Yinghai Lu <yinghai@kernel.org>:
> that is wrong.
> 
> exposed by that patch that doesn's shrink pci bridge res.

Ok, I don't understand how this patch interacts with patch 4/11.
Am I correct in understanding that something in 4/11 exposes a
problem that 3/11 fixes?

I'm just looking for a better explanation of *why* we need this
patch here.

> -v2: change to "bar reading" to "reg reading"
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/probe.c |   18 +++++++++++++++---
>  1 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 11824d7..70b1f74 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -316,13 +316,17 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
>  		limit |= (io_limit_hi << 16);
>  	}
>  
> -	if (base <= limit) {
> +	if (base <= limit && base) {

This construct (and the similar one below) is a little
non-idiomatic.

	if (base && base <= limit)

reads a lot more naturally to me.

thanks,
/ac
