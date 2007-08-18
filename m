Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbXHRBxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbXHRBxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 21:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbXHRBxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 21:53:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58259 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbXHRBxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 21:53:42 -0400
Subject: Re: [PATCH] i386: optimize memset of 6 and 8 bytes
From: Arjan van de Ven <arjan@infradead.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20070817165030.5455f761@freepuppy.rosehill.hemminger.net>
References: <20070817165030.5455f761@freepuppy.rosehill.hemminger.net>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 17 Aug 2007 18:49:34 -0700
Message-Id: <1187401774.2789.0.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 (2.11.6.1-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-08-17 at 16:50 -0700, Stephen Hemminger wrote:
> Tne network code does memset for 6 and 8 byte values, that can easily
> be optimized into simple assignments without string instructions.


so... question.
Why are we doing this by hand? Wouldn't gcc just generate this code in
the first place (when using __builtin_memset)? I very much suspect it
would (and if some version doesn't.... we really ought to get that
fixed)

