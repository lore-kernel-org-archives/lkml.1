Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYEPUx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYEPUx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759358AbYEPUxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:53:39 -0400
Received: from xes-mad.com ([216.165.139.214]:50144 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758669AbYEPUxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:53:38 -0400
Subject: Re: [PATCH] leds: Add support for Philips PCA955x I2C LED drivers
From: Nate Case <ncase@xes-inc.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080515163331.0677f4b1.akpm@linux-foundation.org>
References: <1210808866.13845.428.camel@localhost.localdomain>
	 <20080515163331.0677f4b1.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 16 May 2008 15:52:56 -0500
Message-Id: <1210971176.13845.533.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-15 at 16:33 -0700, Andrew Morton wrote:
> Please prefer to implement code in C rather than as a macro.  Only use
> macros when the code *must* be a macro.
[snip]

Thanks for the feedback.  I've implemented all of your suggestions and
tested them.  The only place I deviated was here:

> > +	if (((client->addr >> chip->slv_addr_shift) << chip->slv_addr_shift)
> > +		!= chip->slv_addr) {
> 
> equivalent to the simpler
> 
> 	if (client->addr & ((1 << chip->slv_addr_shift) - 1)) {
> 
> I think?

I inserted the missing "~" from your version:

	if (client->addr & ~((1 << chip->slv_addr_shift) - 1)) !=

I'll send v2 of the patch shortly.

-- 
Nate Case <ncase@xes-inc.com>

