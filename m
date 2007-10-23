Return-Path: <linux-kernel-owner+w=401wt.eu-S1752858AbXJWUSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbXJWUSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbXJWUSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:18:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbXJWUSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:18:22 -0400
Date: Tue, 23 Oct 2007 16:17:50 -0400
From: Dave Jones <davej@redhat.com>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] LinuxPPS - PPS support for Linux
Message-ID: <20071023201750.GE7793@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Woodhouse <dwmw2@infradead.org>
References: <20071023180417.GM9748@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023180417.GM9748@enneenne.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 08:04:18PM +0200, Rodolfo Giometti wrote:

Hi Rodolfo,
 
 > here my last patch for PPS support.
 > 
 > Please, let me know if I have something to do for kernel inclusion.

Thanks for trying to get this merged, we've had a few users asking
us to support this in the Fedora kernel.

>From a quick look through, it doesn't look too bad.
A couple of obvious things that jumped out..

* The example program in the Documentation dir.
  There was some discussion recently about moving away 
  from doing this, and instead moving code to the samples/ dir
  (or including it in util-linux instead if applicable).

 > +    static struct pps_source_info_s pps_ktimer_info = {
 > +            name         : "ktimer",
 > +            path         : "",
 > +            mode         : PPS_CAPTUREASSERT | PPS_OFFSETASSERT | \
 > +			   PPS_ECHOASSERT | \
 > +                           PPS_CANWAIT | PPS_TSFMT_TSPEC,
 > +            echo         : pps_ktimer_echo,
 > +            owner        : THIS_MODULE,
 > +    };

  should be
    .name = "ktimer"
  etc..

 > +#include <linux/version.h>

This should be getting included automatically for you.

On the whole, asides from these (very) minor nits, quite a clean
submission compared to a lot of new driver submissions to lkml.
Might want to run it through scripts/checkpatch.pl too to see
if that picks up any more minor fluff.

	Dave

-- 
http://www.codemonkey.org.uk
