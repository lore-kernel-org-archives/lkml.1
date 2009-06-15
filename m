Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbZFOI1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbZFOI1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759060AbZFOI1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:27:32 -0400
Received: from www.tglx.de ([62.245.132.106]:34647 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759508AbZFOI1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:27:31 -0400
Date: Mon, 15 Jun 2009 10:27:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhltc@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug: fio traps into kernel without exiting because futex has a
 deadloop
In-Reply-To: <1245045817.2560.363.camel@ymzhang>
Message-ID: <alpine.LFD.2.00.0906151024260.2800@localhost.localdomain>
References: <1244689688.2560.268.camel@ymzhang>  <1244699756.6691.4.camel@laptop>  <1244701128.6691.5.camel@laptop>  <1244709196.2560.287.camel@ymzhang>  <1244720183.6691.214.camel@laptop>  <1244768378.2560.297.camel@ymzhang>  <alpine.LFD.2.00.0906121010210.3369@localhost.localdomain>
  <alpine.LFD.2.00.0906121036220.3369@localhost.localdomain> <1245045817.2560.363.camel@ymzhang>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Zhang, Yanmin wrote:
> On Fri, 2009-06-12 at 10:39 +0200, Thomas Gleixner wrote:
>
> > +	ret = get_user_writeable(uaddr);
>
> X86 pte entry has no READABLE flag. Other platforms might have. If their pte
> only set WRITE flag, Is it poosible to create a similiar DOS attack with
> WRITEONLY area on such platforms?

Just checked with Peter. The kernel assumes that when its present we
can read. We looked at the arches that do support wr-only and it seems
that this is a valid assumption. i.e. we don't support wr-only
mappings.

Thanks,

	tglx
