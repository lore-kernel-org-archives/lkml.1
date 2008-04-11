Return-Path: <linux-kernel-owner+w=401wt.eu-S1760000AbYDKLFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000AbYDKLFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 07:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759386AbYDKLE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 07:04:58 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:34069 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757131AbYDKLE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:04:57 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-5.tower-29.messagelabs.com!1207911897!8809006!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Fri, 11 Apr 2008 13:03:58 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 v2] [RFC] UIO: generic platform driver
Message-ID: <20080411110358.GC19973@digi.com>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-5-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080410224804.GI3193@local> <20080411062106.GA18096@digi.com> <20080411092158.GB31625@digi.com> <20080411103346.GC3185@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080411103346.GC3185@local>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 11 Apr 2008 11:03:58.0984 (UTC) FILETIME=[BE120880:01C89BC3]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15842.003
X-TM-AS-Result: No--16.954000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Hans J. Koch wrote:
> On Fri, Apr 11, 2008 at 11:21:58AM +0200, Uwe Kleine-König wrote:
> > 
> > Below is a new version that uses linux/stringify and zeros size for
> > unused mappings (line 102ff).
> 
> Thanks, but it doesn't compile, neither with -rc8 nor with Linus' git.
> 
> One problem can easily be fixed, the macro is called __stringify, not
> stringify.
I just notice that, too.  My mail address that and your's just crossed
each other.
 
> But what about this:
> 
> ERROR: "clk_get" [drivers/uio/uio_pdrv.ko] undefined!
> ERROR: "clk_enable" [drivers/uio/uio_pdrv.ko] undefined!
> ERROR: "clk_disable" [drivers/uio/uio_pdrv.ko] undefined!
> ERROR: "clk_put" [drivers/uio/uio_pdrv.ko] undefined!
> 
> Do you have any extra patches applied?
Yes I have, but nothing special.  This is part of a generic API defined
in include/linux/clk.h.  One of it's use it to abstract away some
platform dependencies.  There are several architectures that define
it[1].  I used it to allow enabling the device only when the device is
opened.  Typical things in the enable routine are enabling a clock or
reserve and configure gpios etc.

A minimal dummy implementation that should work here is:

	#define clk_get(dev, id)	NULL
	#define clk_put(clk)		((void)0)
	#define clk_enable(clk)		(1)
	#define clk_disable(clk)	((void)0)

Best regards
Uwe

[1] Try:

	git ls-files -z | xargs -0 perl -n -e 'print "$ARGV\n" if /EXPORT_SYMBOL(?:_GPL)?\s*\(\s*clk_get\s*\)/;'

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
