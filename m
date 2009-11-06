Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbZKFFtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbZKFFtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 00:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZKFFtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 00:49:50 -0500
Received: from yumi.tdiedrich.de ([85.10.210.183]:55679 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZKFFtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 00:49:50 -0500
Date: Fri, 6 Nov 2009 06:49:54 +0100
From: Tobias Diedrich <ranma@tdiedrich.de>
To: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: netconsole: tulip: possible remote DoS? due to kernel freeze
	on heavy RX traffic after Order-1 allocation failure
Message-ID: <20091106054954.GA5387@yumi.tdiedrich.de>
Mail-Followup-To: Tobias Diedrich <ranma@tdiedrich.de>,
	Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
References: <20091105113106.GA4373@yumi.tdiedrich.de> <1257450578.2873.609.camel@calx> <20091106032754.GA15429@yumi.tdiedrich.de> <1257484384.2873.618.camel@calx> <20091106052505.GA3912@yumi.tdiedrich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091106052505.GA3912@yumi.tdiedrich.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> Matt Mackall wrote:
> > Running out of order-1 buffers hasn't been a problem for most people
> > lately though - is there anything interesting about your workload? Lots
> > of threads? NFS? Long network processing latencies?

BTW I think that the allocator bug in 2.6.31 is responsible for me
seeing these allocation failures, since I never had problems with
older kernels.
http://lkml.org/lkml/2009/10/22/128

However since I can reproduce it even on 2.6.30 (and presumably even
older kernels) with enough memory pressure and it causes the kernel
to hang with netconsole enabled (see my other followup, it seems to be
fine without netconsole) I think this should be fixed to not
hang the kernel.

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
