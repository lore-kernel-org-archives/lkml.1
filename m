Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbZFDP6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbZFDP6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 11:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbZFDP6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 11:58:03 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2554 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbZFDP6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:58:01 -0400
Subject: Re: [PATCH 1/8] add lib/gcd.c
From: Joe Perches <joe@perches.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       Linux-MIPS <linux-mips@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Takashi Iwai <tiwai@suse.de>, Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <200906041639.04868.florian@openwrt.org>
References: <200906041615.10467.florian@openwrt.org>
	 <4A27DAAD.5000303@ru.mvista.com>  <200906041639.04868.florian@openwrt.org>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 08:57:24 -0700
Message-Id: <1244131044.3631.14.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-04 at 16:39 +0200, Florian Fainelli wrote:
> diff --git a/lib/gcd.c b/lib/gcd.c
> new file mode 100644
> index 0000000..6634741
> --- /dev/null
> +++ b/lib/gcd.c
> @@ -0,0 +1,20 @@
> +#include <linux/gcd.h>
> +#include <linux/module.h>
> +
> +/* Greatest common divisor */
> +unsigned long gcd(unsigned long a, unsigned long b)
> +{
> +	unsigned long r;
> +
> +	if (a < b) {
> +		r = a;
> +		a = b;
> +		b = r;
	swap(a, b)
> +	}
> +	while ((r = a % b) != 0) {
> +		a = b;
> +		b = r;
> +	}
> +	return b;
> +}
> +EXPORT_SYMBOL_GPL(gcd);

Shouldn't a generic gcd protect against a div0
if gcd(0,0)?


