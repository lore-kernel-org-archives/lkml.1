Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbYDOHhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbYDOHhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbYDOHhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:37:37 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:35859 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753778AbYDOHhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:37:36 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-9.tower-29.messagelabs.com!1208245055!10954518!3
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Tue, 15 Apr 2008 09:36:41 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] GPIO: #include <linux/kernel.h> for might_sleep
Message-ID: <20080415073641.GA16930@digi.com>
References: <1207902290-25381-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <200804111005.52041.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200804111005.52041.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 15 Apr 2008 07:36:41.0779 (UTC) FILETIME=[72922830:01C89ECB]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15850.005
X-TM-AS-Result: No--17.533000-8.000000-1
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

David Brownell wrote:
> On Friday 11 April 2008, Uwe Kleine-König wrote:
> > I like having headers being independend of the order of inclusion.
> 
> That's a pretty unusual policy.  Not one that's generally
> followed in the kernel, either ... 
It's usual for the system headers.  IIRC I read that in the SUSV3 spec,
but I cannot find it at the moment.
 
> > Usually I order all includes alphabetically (and grouped by linux/,
> > asm/, etc.). 
> 
> If you like alphabetical, why the exception for <asm/...> ??
> :)
> 
> > This doesn't work with gpio.h because then kernel.h is 
> > included to late.
> 
> So include <linux/kernel.h> first.  There *is* a policy
> of avoiding extra #includes ... extras slow down builds.
Is it really a slow down if you need <linux/kernel.h> unconditionally?
I thought it's fine to skip #include <header2.h> in header1.h if not all
users of header1.h need header2.h.

If I try to compile a C file that only consists of an include for
<asm-generic/gpio.h> I get the error:

	In file included from ...:
	include/asm-generic/gpio.h:63: error: expected specifier-qualifier-list before ‘u16’
	include/asm-generic/gpio.h:72: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘gpiochip_remove’

Best regards
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
