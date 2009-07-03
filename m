Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbZGCKup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbZGCKup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbZGCKuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:50:37 -0400
Received: from mga10.intel.com ([192.55.52.92]:62065 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753404AbZGCKug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:50:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,341,1243839600"; 
   d="scan'208";a="471759579"
Date: Fri, 3 Jul 2009 12:52:36 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>
Subject: Re: [PATCH 1/4] MFD/PCAP: fix adc locking
Message-ID: <20090703105235.GE4176@sortiz.org>
References: <1245771058.7750.35.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245771058.7750.35.camel@brutus>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 12:30:58PM -0300, Daniel Ribeiro wrote:
> Release the lock on error.
Applied this one to my for-linus branch, which means I send a pull request to
Linus soon.
The 3 other patches are on my for-next branch.

Cheers,
Samuel.

 
> Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
> 
> ---
>  drivers/mfd/ezx-pcap.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
> index 671a7ef..c1de4af 100644
> --- a/drivers/mfd/ezx-pcap.c
> +++ b/drivers/mfd/ezx-pcap.c
> @@ -238,8 +238,10 @@ static irqreturn_t pcap_adc_irq(int irq, void *_pcap)
>  	mutex_lock(&pcap->adc_mutex);
>  	req = pcap->adc_queue[pcap->adc_head];
>  
> -	if (WARN(!req, KERN_WARNING "adc irq without pending request\n"))
> +	if (WARN(!req, KERN_WARNING "adc irq without pending request\n")) {
> +		mutex_unlock(&pcap->adc_mutex);
>  		return IRQ_HANDLED;
> +	}
>  
>  	/* read requested channels results */
>  	ezx_pcap_read(pcap, PCAP_REG_ADC, &tmp);
> -- 
> tg: (f234012..) pcap/fix-adc-locking (depends on: master)
> 
> -- 
> Daniel Ribeiro



-- 
Intel Open Source Technology Centre
http://oss.intel.com/
