Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbYKTNdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbYKTNdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 08:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbYKTNdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 08:33:35 -0500
Received: from mga06.intel.com ([134.134.136.21]:18182 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754715AbYKTNdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 08:33:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,639,1220252400"; 
   d="scan'208";a="465277881"
Subject: Re: [PATCH] led: simplify led_trigger_register_simple
From: Richard Purdie <rpurdie@linux.intel.com>
To: me@felipebalbi.com
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       Greg KH <greg@kroah.com>, Pierre Ossman <drzeus@drzeus.cx>
In-Reply-To: <20081113191046.GA25855@frodo>
References: <1226545753-6640-1-git-send-email-me@felipebalbi.com>
	 <1226579912.5402.21.camel@dax.rpnet.com> <20081113181407.GC17166@frodo>
	 <20081113191046.GA25855@frodo>
Content-Type: text/plain
Date: Thu, 20 Nov 2008 13:33:28 +0000
Message-Id: <1227188008.22263.9.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-13 at 21:10 +0200, Felipe Balbi wrote:
> On Thu, Nov 13, 2008 at 08:14:16PM +0200, Felipe Balbi wrote:
> > On Thu, Nov 13, 2008 at 12:38:32PM +0000, Richard Purdie wrote:
> > > The simple triggers were designed to cause minimum interference to the
> > > usually external subsystem code they were added into. As an example this
> > > meant things like errors were just handled gracefully with a printk
> > > warning and did not take down the whole subsystem. I therefore don't
> > > regard this patch as a simplification, more a complication.
> > 
> > That's a matter of changing the return ERR_PTR(err); back to a printk.
> 
> And here you are. I still think we should at least kfree(trigger) in
> case of error, though.

This patch now just changes the calling convention of the function which
doesn't seem to serve much purpose.

In answer to your question about kfree, I agree it needs to be called
upon error. The callers should just be calling
led_trigger_unregister_simple() in their failure paths though which
should take care of all problems? I know we used to register the simple
triggers late in paths so no error handling was needed to keep the code
simple and minimise the LED triggers impact on those systems.

Cheers,

Richard

