Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYITAjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYITAjU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 20:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYITAjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 20:39:10 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:25081 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752138AbYITAjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 20:39:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uvhZrjdcaFVjNUrv5N4G8hcxfOjxE4EcYAKxhx7cVTa2wOQcPflFQZpoYWjx1UHcwVm3pXywgmk7dROfDZCL2KUxQePwBBYMYYWKVoXBUc2DGG2I7dURp8LH8xC6MtkaSZ6cDG/CuB1oA5IOnE7y+/XwmzKirBx2ulSgELnBs04=  ;
X-YMail-OSG: sdBxGksVM1kpHxaY_x6..zbPsZxpo2oVxTkVuU37T.cRwqeEtuPtKM3xydTc_nBI_DZZMRSz64D8YhXmsY.9yg7efAjxbh.75rJoe7OHOKEOvUpRUFp5cDwYdE.0p__UgqOt30.n
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [PATCH 1/5] watchdog: sync linux-omap changes
Date: Fri, 19 Sep 2008 17:39:06 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com> <1221820359-8943-2-git-send-email-felipe.balbi@nokia.com>
In-Reply-To: <1221820359-8943-2-git-send-email-felipe.balbi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809191739.06779.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 September 2008, Felipe Balbi wrote:
> +static struct platform_device *omap_wdt_dev;
> +
>  ...
> +struct omap_wdt_dev {
> +       void __iomem    *base;          /* physical */
> +       struct device   *dev;


You don't need both omap_wdt_dev (platform device)
and omap_wdt_dev.dev (hmm, never used).  In fact
the former isn't needed either ... its role seems
to be ensure only one watchdog device gets bound,
which is more naturally done by not registering
more than one such platform device.
 
