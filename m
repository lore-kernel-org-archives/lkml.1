Return-Path: <linux-kernel-owner+w=401wt.eu-S1760934AbXIXS17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760934AbXIXS17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbXIXS1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:27:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:47881 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720AbXIXS1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:27:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,292,1186383600"; 
   d="scan'208";a="285610196"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [RFC] New kernel-message logging API
Date: Mon, 24 Sep 2007 11:26:39 -0700
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>, holzheu <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>, "Rob Landley" <rob@landley.net>,
       "Dick Streefland" <dick.streefland@altium.nl>
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
In-Reply-To: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709241126.41375.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 22, 2007 12:27 pm Vegard Nossum wrote:
> enum kprint_loglevel {
> 	KPRINT_EMERG,	/* kprint_emerg() */
> 	KPRINT_ALERT,	/* kprint_alert() */
> 	KPRINT_CRIT,	/* kprint_crit() */
> 	KPRINT_ERROR,	/* kprint_error() and/or kprint_err() */
> 	KPRINT_WARNING,	/* kprint_warning() and/or kprint_warn() */
> 	KPRINT_NOTICE,	/* kprint_notice() */
> 	KPRINT_INFO,	/* kprint_info() */
> 	KPRINT_DEBUG,	/* kprint_debug() */
> };

I wonder if all these levels are still needed (though I really like the 
error/err & warning/warn aliases, those always get me :).

It seems like fewer levels would make things easier on both kernel 
developers and administrators; looking at current counts may help 
figure out which ones could be combined (warning, very naive grep -r 
data):

KERN_EMERG: 371
KERN_ALERT: 236
KERN_CRIT: 602
KERN_ERR: 11961
KERN_WARNING: 6463
KERN_NOTICE: 1142
KERN_INFO: 8491
KERN_DEBUG: 6125

So KERN_ERR is the most common by a pretty large margin, though it seems 
to me that KERN_NOTICE, KERN_INFO and KERN_DEBUG are mostly redundant 
and probably make up a majority of the "SIMD FPU exception support was 
enabled" (as if I care) type messages.  Likewise, ERR, ALERT, CRIT and 
EMERG serve very similar purposes (i.e. something unrecoverable 
occurred), maybe they could be condensed into one or two levels rather 
than four?  So that would drop us to three levels:

KERN_ERR /* something really bad happened, machine is dead or near so */
KERN_WARNING /* you really ought to know about this */
KERN_INFO /* no one but the kernel developer likely cares about this */

But maybe I'm just living in a dream world where then number of printks 
the kernel spits out suddenly drops by 99% and only actually important 
messages make it to my log...

Jesse
