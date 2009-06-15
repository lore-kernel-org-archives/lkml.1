Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbZFOI16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbZFOI16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759508AbZFOI1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:27:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:50086 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540AbZFOI1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:27:48 -0400
Subject: Re: Bug: fio traps into kernel without exiting because futex has a
 deadloop
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhltc@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1245045817.2560.363.camel@ymzhang>
References: <1244689688.2560.268.camel@ymzhang>
	 <1244699756.6691.4.camel@laptop>  <1244701128.6691.5.camel@laptop>
	 <1244709196.2560.287.camel@ymzhang>  <1244720183.6691.214.camel@laptop>
	 <1244768378.2560.297.camel@ymzhang>
	 <alpine.LFD.2.00.0906121010210.3369@localhost.localdomain>
	 <alpine.LFD.2.00.0906121036220.3369@localhost.localdomain>
	 <1245045817.2560.363.camel@ymzhang>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 10:27:41 +0200
Message-Id: <1245054461.6800.72.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 14:03 +0800, Zhang, Yanmin wrote:
> > +     ret = get_user_writeable(uaddr);
> X86 pte entry has no READABLE flag. Other platforms might have. If their pte
> only set WRITE flag, Is it poosible to create a similiar DOS attack with
> WRITEONLY area on such platforms?

I just checked a few such platforms and generic code, we seem to assume
read on write, and read when present in the generic code.

And those few platforms that supported wr-only also implemented that
(alpha, avr32 -- there might be more didn't go through all).



