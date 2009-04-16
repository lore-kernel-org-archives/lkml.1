Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbZDPQbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbZDPQbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755105AbZDPQbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:31:36 -0400
Received: from n15a.bullet.mail.mud.yahoo.com ([68.142.207.125]:29297 "HELO
	n15a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754482AbZDPQbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:31:36 -0400
X-Yahoo-Newman-Id: 192409.24742.bm@omp403.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Us8UYt+chEnh3L/do1WYNLm8eI94P0Gudwqq6b+r7PQhRE53l6KSGXy4elQmNAjjurEi8tibQQNv2GVTSjtuWm/fRqkoHdY6pIFrHs0hJCgMoaZTiJcy2KWa6ybmHhrpnoaoHDMSpUsB3mFOjtE5fH8iTKLyHEq8K2evefKeKB0=  ;
X-YMail-OSG: 69Crc.oVM1kkWiZDm57n6JUdFjf0Y040.V5W2J_WjQVuhOl9HvmSIOhKFKrir4yl3GeuCrsFdZOCl_MPu6eSlLQ10Dtq5J4QKav2qPKuFf1lhYW2wQxbMxxWpKyFPGPD000jUdBSJBUvyGbU2JSNvr2L8AP_g2O3eBTiPGWCFdn2xKAgikpSnOt_9USGSHVwQHZN.k6PA4KisnF88BCxqhspjMRmXUfF.beI_Nl1.MT0sYBxl5Zz63BN2AOhiGIsxcdIME0sbchvKdqHEULLKbguluSa2y5gPjzVS371GLtDJPX7TYE0QB2jbPp7gHHMNOzrpQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Nizette <bn@niasdigital.com>
Subject: Re: [PATCH] rtc-ds1305: Use disable_irq_nosync() from within irq handlers.
Date: Thu, 16 Apr 2009 09:31:33 -0700
User-Agent: KMail/1.9.10
Cc: p_gortmaker@yahoo.com, "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1239861306.29831.126.camel@linux-51e8.site>
In-Reply-To: <1239861306.29831.126.camel@linux-51e8.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904160931.33419.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 April 2009, Ben Nizette wrote:
> 
> disable_irq() should wait for all running handlers to complete
> before returning.  As such, if it's used to disable an interrupt
> from that interrupt's handler it will deadlock.  This replaces
> the dangerous instances with the _nosync() variant which doesn't
> have this problem.
> 
> Signed-off-by: Ben Nizette <bn@niasdigital.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Also ... it would be nice to convert this driver to the
new request_threaded_irq() infrastructure.  The board I
had with this chip has a busted ttyS0 *input* line, so it's
not much use for development any more; or I'd update it
myself, it's a simple change.  Someone with that hardware
should think about spending the few minutes needed to make
and test that patch.


> ---
> diff --git a/drivers/rtc/rtc-ds1305.c b/drivers/rtc/rtc-ds1305.c
> index fc372df..5c4f789 100644
> --- a/drivers/rtc/rtc-ds1305.c
> +++ b/drivers/rtc/rtc-ds1305.c
> @@ -514,7 +514,7 @@ static irqreturn_t ds1305_irq(int irq, void *p)
>  {
>  	struct ds1305		*ds1305 = p;
>  
> -	disable_irq(irq);
> +	disable_irq_nosync(irq);
>  	schedule_work(&ds1305->work);
>  	return IRQ_HANDLED;
>  }
> -- 
> 1.6.0.2
> 
> 
> 
> 



