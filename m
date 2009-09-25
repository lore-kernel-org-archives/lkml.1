Return-Path: <linux-kernel-owner+w=401wt.eu-S1751977AbZIYR6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbZIYR6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 13:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZIYR6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 13:58:12 -0400
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:21164 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751669AbZIYR6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 13:58:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VyJuPDQareQTyRPIYDw17LjKZEl8010zGc5QyVS+GYwAGsBFhFPHzcrf3bsEthHcsn2nJ7VpnW3a9dbDGBvlt3SAF3FxVmz15OE5N1wjiv0usPuYb5AOKnpldFvEVLunBhIKS1Ec3EoJ5apDGQeapIVNATYFAquHj7UUivlckfA=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: iCMiowgVM1lghQ4VaKY8v2YwyNLG8RywjRVBW7BoZSQPsBZdsy1hx.1yDZLvz9k3xxbIXYiDIQq9YdLY_TUeYTY_NxvBLIelXYINJOrcOeE9ZGsG3Ox4gKP4jWJBE2xB3hHdE1K4qviHF76XTkdKDRWn5CeSaejVETXmVhKC8VRf5kBMnDNDjtv1an0MaZUjZpUWDG8MmZMO2YrfrVh65YlnpmmkkP7vTlyR_h_FBefBRJxWBd9wVjp2LqN91iH_VYI7Cfkr0hHNvwVs.qhR
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 4/5] at91/USB: USB drivers modifications for at91sam9g10
Date: Fri, 25 Sep 2009 10:51:34 -0700
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
       avictor.za@gmail.com, linux-arm-kernel@lists.infradead.org,
       patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       Hong Xu <hong.xu@atmel.com>
References: <1245341772-1689-1-git-send-email-nicolas.ferre@atmel.com> <4AB0D325.9080407@atmel.com> <4ABC9A4C.8000702@atmel.com>
In-Reply-To: <4ABC9A4C.8000702@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909251051.34916.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 September 2009, Nicolas Ferre wrote:
> Greg,
> 
> Please, can you consider the inclusion of this patch. I have no news
> about it for a long time...

ISTR either acking this or suggesting it go with the rest
of the G10 patches ... regardless, seems OK to me now that
its precursors have merged.


> Here is a link to its patchwork entry:
> http://patchwork.kernel.org/patch/31173/
> 
> Thanks for your help.
> 
> Nicolas Ferre :
> > Hi,
> > 
> > Here is a little "ping" about integration of this patch.
> > 
> > Nicolas Ferre :
> >> From: Hong Xu <hong.xu@atmel.com>
> >>
> >> Modify both host and gadget USB drivers for at91sam9g10.
> >> This add a clock management equivalent to at91sam9261 on usb drivers.
> >> It also add the way of handling gadget pull-ups (like the at91sam9261).
> > 
> > I wonder if we can consider its inclusion as at91sam9g10 is now
> > integrated in mainline.
> > Do you want me to split this in several pieces for host/gadget split.
> > 
> > Thanks.
> > 
> >> Signed-off-by: Hong Xu <hong.xu@atmel.com>
> >> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> >> ---
> >>  drivers/usb/gadget/at91_udc.c |    6 +++---
> >>  drivers/usb/host/ohci-at91.c  |   10 +++++-----
> >>  2 files changed, 8 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
> >> index 0b2bb8f..bfed3d9 100644
> >> --- a/drivers/usb/gadget/at91_udc.c
> >> +++ b/drivers/usb/gadget/at91_udc.c
> >> @@ -892,7 +892,7 @@ static void pullup(struct at91_udc *udc, int is_on)
> >>  
> >>  			txvc |= AT91_UDP_TXVC_PUON;
> >>  			at91_udp_write(udc, AT91_UDP_TXVC, txvc);
> >> -		} else if (cpu_is_at91sam9261()) {
> >> +		} else if (cpu_is_at91sam9261() || cpu_is_at91sam9g10()) {
> >>  			u32	usbpucr;
> >>  
> >>  			usbpucr = at91_sys_read(AT91_MATRIX_USBPUCR);
> >> @@ -910,7 +910,7 @@ static void pullup(struct at91_udc *udc, int is_on)
> >>  
> >>  			txvc &= ~AT91_UDP_TXVC_PUON;
> >>  			at91_udp_write(udc, AT91_UDP_TXVC, txvc);
> >> -		} else if (cpu_is_at91sam9261()) {
> >> +		} else if (cpu_is_at91sam9261() || cpu_is_at91sam9g10()) {
> >>  			u32	usbpucr;
> >>  
> >>  			usbpucr = at91_sys_read(AT91_MATRIX_USBPUCR);
> >> @@ -1692,7 +1692,7 @@ static int __init at91udc_probe(struct platform_device *pdev)
> >>  		udc->ep[3].maxpacket = 64;
> >>  		udc->ep[4].maxpacket = 512;
> >>  		udc->ep[5].maxpacket = 512;
> >> -	} else if (cpu_is_at91sam9261()) {
> >> +	} else if (cpu_is_at91sam9261() || cpu_is_at91sam9g10()) {
> >>  		udc->ep[3].maxpacket = 64;
> >>  	} else if (cpu_is_at91sam9263()) {
> >>  		udc->ep[0].maxpacket = 64;
> >> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
> >> index b29b0fe..fb64def 100644
> >> --- a/drivers/usb/host/ohci-at91.c
> >> +++ b/drivers/usb/host/ohci-at91.c
> >> @@ -35,7 +35,7 @@ extern int usb_disabled(void);
> >>  
> >>  static void at91_start_clock(void)
> >>  {
> >> -	if (cpu_is_at91sam9261())
> >> +	if (cpu_is_at91sam9261() || cpu_is_at91sam9g10())
> >>  		clk_enable(hclk);
> >>  	clk_enable(iclk);
> >>  	clk_enable(fclk);
> >> @@ -46,7 +46,7 @@ static void at91_stop_clock(void)
> >>  {
> >>  	clk_disable(fclk);
> >>  	clk_disable(iclk);
> >> -	if (cpu_is_at91sam9261())
> >> +	if (cpu_is_at91sam9261() || cpu_is_at91sam9g10())
> >>  		clk_disable(hclk);
> >>  	clocked = 0;
> >>  }
> >> @@ -142,7 +142,7 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
> >>  
> >>  	iclk = clk_get(&pdev->dev, "ohci_clk");
> >>  	fclk = clk_get(&pdev->dev, "uhpck");
> >> -	if (cpu_is_at91sam9261())
> >> +	if (cpu_is_at91sam9261() || cpu_is_at91sam9g10())
> >>  		hclk = clk_get(&pdev->dev, "hck0");
> >>  
> >>  	at91_start_hc(pdev);
> >> @@ -156,7 +156,7 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
> >>  	/* Error handling */
> >>  	at91_stop_hc(pdev);
> >>  
> >> -	if (cpu_is_at91sam9261())
> >> +	if (cpu_is_at91sam9261() || cpu_is_at91sam9g10())
> >>  		clk_put(hclk);
> >>  	clk_put(fclk);
> >>  	clk_put(iclk);
> >> @@ -193,7 +193,7 @@ static void usb_hcd_at91_remove(struct usb_hcd *hcd,
> >>  	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
> >>  	usb_put_hcd(hcd);
> >>  
> >> -	if (cpu_is_at91sam9261())
> >> +	if (cpu_is_at91sam9261() || cpu_is_at91sam9g10())
> >>  		clk_put(hclk);
> >>  	clk_put(fclk);
> >>  	clk_put(iclk);
> > 
> > 
> 
> 
> -- 
> Nicolas Ferre
> 
> 


