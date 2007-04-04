Return-Path: <linux-kernel-owner+w=401wt.eu-S2993043AbXDDTN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993043AbXDDTN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 15:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993044AbXDDTN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 15:13:59 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:48453 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2993043AbXDDTN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 15:13:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mPbM0KELWCqGV7rWtf5KCNGXyoxydVLt326YEtaJp7xNzJwIrKmN849G7Y+UbAsg1Pp7reslXCiVWfMgXYJho5tE+N86FXaC/+wzfrH1rfMqWxPKHam2iCkTrbk64mWky9v1byqRdIuTfxLzHmDUuIm1wbcWp4Wq9sKPOIq95SU=  ;
X-YMail-OSG: SuAPF9kVM1mx2M3nLFYqlUJmc6g.ZwqOmVLLZlic101OkVKJfGEYKvA5M1oWU7z7.5PScsUaRw--
From: David Brownell <david-b@pacbell.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 25/90] ARM: OMAP: h4 must have blinky leds!!
Date: Wed, 4 Apr 2007 12:13:52 -0700
User-Agent: KMail/1.7.1
Cc: Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
References: <11757099691323-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <20070404120025.4c5548dc.randy.dunlap@oracle.com>
In-Reply-To: <20070404120025.4c5548dc.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704041213.52777.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007 12:00 pm, Randy Dunlap wrote:
> On Wed,  4 Apr 2007 14:05:04 -0400 Tony Lindgren wrote:
> 
> > +static int __init fpga_init(void)
> > +{
> > +	if (machine_is_omap_h4()
> > +			|| machine_is_omap_h3()
> > +			|| machine_is_omap_h2()
> > +			|| machine_is_omap_perseus2()
> > +			)
> 
> Perhaps there is nothing in CodingStyle for if () continuation
> lines.  Looks like it is needed.  This is ETOOMUCHINDENTATION by
> at least one tab.  Should be more like:
> 
> +	if (machine_is_omap_h4()
> +	    || machine_is_omap_h3()
> +	    || machine_is_omap_h2()
> +	    || machine_is_omap_perseus2())

That's clearly wrong -- it uses non-tab characters for indents.

Which means that unless you think

	if (this_longthing
		|| that longthing
		|| another
		...)
		the condition;

is correct (nope!), those additional conditions need more indents.

> 
> (without getting into where the "||" should be placed).
> 
> > +		return platform_driver_register(&led_driver);
> > +	return 0;
> > +}
> > +fs_initcall(fpga_init);
> 
> fs, eh?

That basically means "after subsys init and before other drivers", yes?
For platform level init code, that's a fairly significant category.

- Dave
