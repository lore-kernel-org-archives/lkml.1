Return-Path: <linux-kernel-owner+w=401wt.eu-S1757739AbZGQFAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739AbZGQFAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 01:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757663AbZGQFAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 01:00:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49481 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbZGQFAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 01:00:42 -0400
Date: Thu, 16 Jul 2009 21:56:20 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Barry Song <21cnbao@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: sound tree build failure
Message-ID: <20090717045620.GC17656@kroah.com>
References: <20090717112935.2e831eee.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090717112935.2e831eee.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 11:29:35AM +1000, Stephen Rothwell wrote:
> Hi Takashi,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> sound/soc/codecs/ad1938.c: In function 'ad1938_spi_probe':
> sound/soc/codecs/ad1938.c:423: error: 'struct device' has no member named 'driver_data'
> sound/soc/codecs/ad1938.c: In function 'ad1938_spi_remove':
> sound/soc/codecs/ad1938.c:430: error: 'struct device' has no member named 'driver_data'
> 
> Caused by commit 1274738d85d0e25c4f82d83f50a6bcbe2397e9ea ("ASoC: new
> ad1938 codec driver based on asoc") interacting with commit
> 2e34003ff6237e2216396d61dc8b32ea5959de80 ("Driver core: move
> dev_get/set_drvdata to drivers/base/dd.c") from the driver-core.current
> tree (which will, I assume, be sent to Linus shortly - right, Greg?).

It turned out to be "too late" to make the change, I missed the -rc2
window, so it will be a .32 thing.

I'll move it from my driver-core.current to my driver-core tree to clear
up any confusion.

But yes, the apis should be used instead of directly accessing the
fields.

thanks,

greg k-h
