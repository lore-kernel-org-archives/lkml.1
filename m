Return-Path: <linux-kernel-owner+w=401wt.eu-S1757766AbZKEXpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbZKEXpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 18:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbZKEXpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 18:45:12 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55124 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbZKEXpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 18:45:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 6 Nov 2009 08:42:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: Re: [MM] Make mm counters per cpu instead of atomic
Message-Id: <20091106084238.cbecd8ef.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.1.10.0911051008260.25718@V090114053VZO-1>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>
	<20091105101650.45204e4e.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.10.0911051008260.25718@V090114053VZO-1>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009 10:10:56 -0500 (EST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Thu, 5 Nov 2009, KAMEZAWA Hiroyuki wrote:
> 
> > Hmm, I don't fully understand _new_ percpu but...
> > In logical (even if not realistic), x86-32 supports up to 512 ? cpus in Kconfig.
> > BIGSMP.
> 
> x86-32 only supports 32 processors. Plus per cpu areas are only allocated
> for the possible processors.
> 
My number is just from Kconfig.

> > Then, if 65536 process runs, this consumes
> >
> > 65536(nr_proc) * 8 (size) * 512(cpus) = 256MBytes.
> 
> With 32 possible cpus this results in 16m of per cpu space use.
> 
If swap_usage is added, 24m, 25% of vmalloc area.
(But, yes, returning -ENOMEM to fork() is ok to me, 65536 proc are extreme.)

Thanks,
-Kame

