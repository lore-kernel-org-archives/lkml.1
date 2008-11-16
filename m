Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbYKPKtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbYKPKtV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 05:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYKPKtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 05:49:13 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:46460 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbYKPKtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 05:49:12 -0500
Date: Sun, 16 Nov 2008 16:19:04 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org, mingo@elte.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ftrace: Add debug_print trace to print data from
	kernel to userspace
Message-ID: <20081116104904.GB25788@skywalker>
References: <1226659566-28168-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1226659566-28168-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <c62985530811140321p481354f9j489955c1e9ee1f3f@mail.gmail.com> <20081114134600.GA29700@skywalker> <c62985530811140639k1004a8f9k968c3e0949d1a309@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530811140639k1004a8f9k968c3e0949d1a309@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 03:39:29PM +0100, Frédéric Weisbecker wrote:
> 2008/11/14 Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>:
> > We also want to make sure dp_printk doesn't do anything when tracer
> > is disabled. We do
> >
> > int do_dp_printk(const char *fmt, ...)
> > {
> >        int ret;
> >        va_list args;
> >
> >        if (!tracer_enabled)
> >                return 0;
> 
> 
> In this case you just have to do
> echo 0 > /debug/tracing/tracing_enabled
> And the entries will not be printed anymore....

That would prevent us to have both dp_printk and debug_dump
used at the same time. Both will them depend on the tracer_enabled
flag. That means the output of these call will also interact with
rest of the tracer output.

-aneesh
