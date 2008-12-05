Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbYLEDN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbYLEDN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 22:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYLEDNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 22:13:18 -0500
Received: from vps1.tull.net ([66.180.172.116]:46753 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753492AbYLEDNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 22:13:18 -0500
Date: Fri, 5 Dec 2008 14:13:12 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use vprintk rather that vsnprintf where possible
Message-ID: <20081205031312.GA1381@mail.local.tull.net>
References: <1228423309.3255.109.camel@calx> <ac3eb2510812041905j639ea7d4ybe8e83b0d7c5965e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510812041905j639ea7d4ybe8e83b0d7c5965e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 04:05:06AM +0100, Kay Sievers wrote:
> On Thu, Dec 4, 2008 at 21:41, Matt Mackall <mpm@selenic.com> wrote:
> > This does away with lots of large static and on-stack buffers as well
> > as a few associated locks.
> 
> > -               len = snprintf(s, 256, KERN_DEBUG "%s: ", prefix);
> > -
> >                va_start(args, fmt);
> > -               len += vsnprintf(&s[len], (256 - len), fmt, args);
> > +               printk(KERN_DEBUG "%s: ", prefix);
> > +               vprintk(fmt, args);
> 
> If we convert to two printk calls for a single line, does that not
> possibly get mixed up with printks from other locations and lead to
> hardly readable log output?

That's right.

Nick.
