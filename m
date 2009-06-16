Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbZFPDQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbZFPDQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 23:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbZFPDQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 23:16:31 -0400
Received: from mga06.intel.com ([134.134.136.21]:34588 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751372AbZFPDQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 23:16:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,225,1243839600"; 
   d="scan'208";a="422226601"
Subject: Re: Bug: fio traps into kernel without exiting because futex has a
	deadloop
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhltc@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0906150954540.2800@localhost.localdomain>
References: <1244689688.2560.268.camel@ymzhang>
	 <1244699756.6691.4.camel@laptop>  <1244701128.6691.5.camel@laptop>
	 <1244709196.2560.287.camel@ymzhang>  <1244720183.6691.214.camel@laptop>
	 <1244768378.2560.297.camel@ymzhang>
	 <alpine.LFD.2.00.0906121010210.3369@localhost.localdomain>
	 <alpine.LFD.2.00.0906121036220.3369@localhost.localdomain>
	 <1245045817.2560.363.camel@ymzhang>
	 <alpine.LFD.2.00.0906150954540.2800@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 16 Jun 2009 11:16:35 +0800
Message-Id: <1245122195.2560.369.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 09:57 +0200, Thomas Gleixner wrote:
> On Mon, 15 Jun 2009, Zhang, Yanmin wrote:
> > > +	ret = get_user_pages_fast(addr, 1, 1, &page);
> >
> > I checked function ﻿get_user_pages_fast. It might return negative, 0, or
> > positive value. 0 means it doesn't pin any page. So why does below statement
> > use (!ret) to put_page?
> 
> Hmm, darn. You are right. It needs to be (ret > 0)
I tested (ret > 0). It does work and I didn't find memory leak.


