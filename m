Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbZGAIHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbZGAIHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZGAIHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:07:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:34644 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbZGAIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:07:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,322,1243839600"; 
   d="scan'208";a="426771115"
Date: Wed, 1 Jul 2009 10:09:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, laforge@openezx.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MFD: ezx-pcap, fix lock imbalance
Message-ID: <20090701080914.GA5840@sortiz.org>
References: <1246431187-23684-1-git-send-email-jirislaby@gmail.com> <1246431871.19661.8.camel@brutus>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1246431871.19661.8.camel@brutus>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Wed, Jul 01, 2009 at 04:04:31AM -0300, Daniel Ribeiro wrote:
> Hi Jiri,
> 
> Em Qua, 2009-07-01 às 08:53 +0200, Jiri Slaby escreveu:
> > There is an omitted unlock in pcap_adc_irq ISR on one fail path. Fix that.
> > 
> > Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> I would be happy to ack this, however, you are late. ;)
> 
> http://patchwork.kernel.org/patch/32002/
> 
> Samuel seems to be unreachable ATM, last email I have from him is from
> June 16. :(
Sorry for the delay, I was travelling. I'll be going through my mail backlog
today.

Cheers,
Samuel.


> > ---
> >  drivers/mfd/ezx-pcap.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
> > index 671a7ef..c1de4af 100644
> > --- a/drivers/mfd/ezx-pcap.c
> > +++ b/drivers/mfd/ezx-pcap.c
> > @@ -238,8 +238,10 @@ static irqreturn_t pcap_adc_irq(int irq, void *_pcap)
> >  	mutex_lock(&pcap->adc_mutex);
> >  	req = pcap->adc_queue[pcap->adc_head];
> >  
> > -	if (WARN(!req, KERN_WARNING "adc irq without pending request\n"))
> > +	if (WARN(!req, KERN_WARNING "adc irq without pending request\n")) {
> > +		mutex_unlock(&pcap->adc_mutex);
> >  		return IRQ_HANDLED;
> > +	}
> >  
> >  	/* read requested channels results */
> >  	ezx_pcap_read(pcap, PCAP_REG_ADC, &tmp);
> 
> -- 
> Daniel Ribeiro



-- 
Intel Open Source Technology Centre
http://oss.intel.com/
