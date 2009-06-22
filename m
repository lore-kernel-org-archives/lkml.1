Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbZFVJ4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbZFVJ4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 05:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbZFVJ4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 05:56:35 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:50040 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbZFVJ4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 05:56:34 -0400
Subject: Re: [PATCH] kmemleak: use pr_fmt
From: Catalin Marinas <catalin.marinas@arm.com>
To: Joe Perches <joe@perches.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1245440992.6201.17.camel@Joe-Laptop>
References: <1245341337.29927.8.camel@Joe-Laptop.home>
	 <1245405220.12653.25.camel@pc1117.cambridge.arm.com>
	 <1245440992.6201.17.camel@Joe-Laptop>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 22 Jun 2009 10:55:52 +0100
Message-Id: <1245664552.15580.36.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jun 2009 09:55:53.0811 (UTC) FILETIME=[A1A2DA30:01C9F31F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 12:49 -0700, Joe Perches wrote:
> On Fri, 2009-06-19 at 10:53 +0100, Catalin Marinas wrote:
> > Thanks for the patch. It missed one pr_info case (actually invoked via
> > the pr_helper macro).
> 
> This change will affect the seq_printf uses.
> Some think the seq output should be immutable.
> Perhaps that's important to you or others.

My point was that with your patch, the kmemleak kernel messages with
pr_info were something like:

kmemleak: kmemleak: unreferenced object ...
kmemleak:   comm ...
kmemleak:   backtrace:

After dropping "kmemleak: " in the print_helper() call, kernel messages
become (which I find nicer):

kmemleak: unreferenced object ...
kmemleak:   comm ...
kmemleak:   backtrace:

For the seq_printf() we really don't need the "kmemleak: " prefix since
you read a kmemleak-specific file anyway. With my modification, the seq
output becomes:

unreferenced object ...
  comm ...
  backtrace:

i.e. without the "kmemleak: " prefix on the "unreferenced ..." line.

-- 
Catalin

