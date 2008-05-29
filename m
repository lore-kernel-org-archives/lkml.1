Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbYE2SYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbYE2SYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbYE2SYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:24:30 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60284 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbYE2SY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:24:29 -0400
Date: Thu, 29 May 2008 20:25:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Philipp Marek <philipp@marek.priv.at>
Cc: linux-trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] removes casting of (void*) private structure members
Message-ID: <20080529182510.GA15712@uranus.ravnborg.org>
References: <200805291933.54529@marek.priv.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805291933.54529@marek.priv.at>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 07:33:54PM +0200, Philipp Marek wrote:
> Hello everybody,
> 
> here's another trivial patch, against v2.6.26-rc3-243-gd40ace0.

Sample from your patch:
 static int geode_rng_data_read(struct hwrng *rng, u32 *data)
 {
-       void __iomem *mem = (void __iomem *)rng->priv;
+       void __iomem *mem = rng->priv;

And from hw_random.h:
struct hwrng {
        const char *name;
        int (*init)(struct hwrng *rng);
        void (*cleanup)(struct hwrng *rng);
        int (*data_present)(struct hwrng *rng, int wait);
        int (*data_read)(struct hwrng *rng, u32 *data);
        unsigned long priv;

        /* internal. */
        struct list_head list;
};


So rng->priv is unsigend long.
Therefore the cast is legitimate.

And I expect gcc to emit:
warning: assignment makes pointer from integer without a cast


	Sam
