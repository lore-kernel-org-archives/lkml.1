Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbXKSFoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbXKSFoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 00:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbXKSFoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 00:44:14 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34494 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbXKSFoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 00:44:13 -0500
Date: Sun, 18 Nov 2007 21:42:00 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Need help with register_page_fault_notifier() replacement in
 2.6.24
Message-ID: <20071118214200.526075a6@laptopd505.fenrus.org>
In-Reply-To: <20071119002946.8rpx77tm8okk48g4@webmail.spamcop.net>
References: <1195407616.26789.15.camel@dv>
	<20071118141741.28738bee@laptopd505.fenrus.org>
	<20071119002946.8rpx77tm8okk48g4@webmail.spamcop.net>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 00:29:46 -0500
Pavel Roskin <proski@gnu.org> wrote:

> Quoting Arjan van de Ven <arjan@infradead.org>:
> 
> > if it's just for a custom case (as it sounds like).. a simple small
> > change to the pagefault handler sounds like the easiest thing to
> > do... (eg just a direct function call to what would have been your
> > notifier)
> 
> Thanks!  Actually, the idea is to make it easy many people to run
> the trace without having them to patch or downgrade their kernels.
> Also, it would be convenient for ath5k developers to run (and
> perhaps improve) the trace on the current development kernel.
> 
> Also, the code was lifted from some nvidia debugging tool, so the  
> improved code could be contributed back there.
> 
> I guess if there is no simple answer, I'll have to try a few crazy  
> ideas.  If nothing works, the fault handler chain could be
> reinstated, perhaps as a separate configuration option.

a generic "IO trace"  function (as config
option) sounds actually like a good idea... that could do a direct call
if the config option is enabled (as well as some sysctl thing I
suspect, so that you can turn it on and off as you want)... I would
entirely support one of those going to mainline.

The problem with a chain is that those are quite expensive to run, and
page faults should really be a fast operation... so the normal case
should be a light as possible.

> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
