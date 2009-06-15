Return-Path: <linux-kernel-owner+w=401wt.eu-S1755627AbZFOH62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627AbZFOH62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 03:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbZFOH6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 03:58:21 -0400
Received: from www.tglx.de ([62.245.132.106]:36797 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZFOH6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 03:58:20 -0400
Date: Mon, 15 Jun 2009 09:57:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhltc@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bug: fio traps into kernel without exiting because futex has a
 deadloop
In-Reply-To: <1245045817.2560.363.camel@ymzhang>
Message-ID: <alpine.LFD.2.00.0906150954540.2800@localhost.localdomain>
References: <1244689688.2560.268.camel@ymzhang>  <1244699756.6691.4.camel@laptop>  <1244701128.6691.5.camel@laptop>  <1244709196.2560.287.camel@ymzhang>  <1244720183.6691.214.camel@laptop>  <1244768378.2560.297.camel@ymzhang>  <alpine.LFD.2.00.0906121010210.3369@localhost.localdomain>
  <alpine.LFD.2.00.0906121036220.3369@localhost.localdomain> <1245045817.2560.363.camel@ymzhang>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-961564888-1245052679=:2800"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-961564888-1245052679=:2800
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 15 Jun 2009, Zhang, Yanmin wrote:
> > +	ret = get_user_pages_fast(addr, 1, 1, &page);
>
> I checked function ﻿get_user_pages_fast. It might return negative, 0, or
> positive value. 0 means it doesn't pin any page. So why does below statement
> use (!ret) to put_page?

Hmm, darn. You are right. It needs to be (ret > 0)

Thanks,

	tglx
--8323328-961564888-1245052679=:2800--
