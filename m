Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbZFSHy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbZFSHy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbZFSHyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:54:17 -0400
Received: from smtp108.sbc.mail.gq1.yahoo.com ([67.195.14.111]:37007 "HELO
	smtp108.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752619AbZFSHyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:54:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rgrZ5VEHd1pPAO46yH7hJPhnjgBlf0k7exDkBFXBuZ9Fldx632gNAvdqYQploFAfLTWrNOoSiUZydC6+NwWkAix5vbpVvC+WPVCi5tpMcGgDGBu41eY3VD9EtD58o4i0O8YrdjjxPfhRZgk/h3TeP3me98wAeMiaz8Y2ynqMF0A=  ;
X-YMail-OSG: 77Z3SB8VM1ma6Wxf2OpuOnP9lLJkHtAdqZACJrpCO_P5JXq4sZK7d3TfbvK.Z3_HwW0m2ejICazSm.nS9B6f7KudaGfdP8AmLwB3GoQqeyiZ9i24YiFPpNbbPg.Wj7Ye43A46VKj.Rlhg47ACet9CGMwNZV601Jjm8DgkIhG7c_OcVyRdpDiWG.oNT23Hzg6UhfRSSDArSPVM8lwX1NT5IPDnyIfk4YfGWXwObLL3C0qNX0E9nyn79FuNrrFmPoxwd1szTs87IMqKzuL
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 1/2 v2] at91/USB: Add USB drivers for at91sam9g45 series
Date: Fri, 19 Jun 2009 00:54:16 -0700
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, patrice.vilchez@atmel.com
References: <1244720355-10740-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1244720355-10740-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906190054.16418.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 June 2009, Nicolas Ferre wrote:
> --- a/drivers/usb/host/ohci-at91.c
> +++ b/drivers/usb/host/ohci-at91.c

Again, please split this out:  OHCI patches separate from EHCI.


> @@ -148,7 +148,8 @@ static int usb_hcd_at91_probe(const struct hc_driver
> *driver, at91_start_hc(pdev);
>         ohci_hcd_init(hcd_to_ohci(hcd));
>  
> -       retval = usb_add_hcd(hcd, pdev->resource[1].start, IRQF_DISABLED);
> +       retval = usb_add_hcd(hcd, pdev->resource[1].start,
> +                               IRQF_DISABLED | IRQF_SHARED);

Just pass IRQF_SHARED.  That combination is not going be effective.
