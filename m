Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbYJCQCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbYJCQCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 12:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYJCQCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 12:02:44 -0400
Received: from rcpt-mqugw.biglobe.ne.jp ([133.205.19.69]:53054 "EHLO
	rcpt-mqugw.biglobe.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbYJCQCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 12:02:43 -0400
X-Greylist: delayed 2131 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Oct 2008 12:02:43 EDT
X-Biglobe-Sender: <d-nishimura@mtf.biglobe.ne.jp>
Date: Sat, 4 Oct 2008 00:25:30 +0900
From: Daisuke Nishimura <d-nishimura@mtf.biglobe.ne.jp>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: d-nishimura@mtf.biglobe.ne.jp,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 3/6] memcg: charge-commit-cancel protocl
Message-Id: <20081004002530.776d4592.d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <2964081.1223046917168.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081003190509.e33a3843.nishimura@mxp.nes.nec.co.jp>
	<20081001165233.404c8b9c.kamezawa.hiroyu@jp.fujitsu.com>
	<20081001165734.e484cfe4.kamezawa.hiroyu@jp.fujitsu.com>
	<2964081.1223046917168.kamezawa.hiroyu@jp.fujitsu.com>
Reply-To: nishimura@mxp.nes.nec.co.jp
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Oct 2008 00:15:17 +0900 (JST)
kamezawa.hiroyu@jp.fujitsu.com wrote:

> ----- Original Message -----
> >> precharge/commit/cancel can be used for other places,
> >>  - shmem, (and other places need precharge.)
> >>  - move_account(force_empty) etc...
> >> we'll revisit later.
> >> 
> >> Changelog v5 -> v6:
> >>  - added newpage_charge() and migrate_fixup().
> >>  - renamed  functions for swap-in from "swap" to "swapin"
> >>  - add more precise description.
> >> 
> >
> >I don't have any objection to this direction now, but I have one quiestion.
> >
> >Does mem_cgroup_charge_migrate_fixup need to charge a newpage,
> >while mem_cgroup_prepare_migration has charged it already?
> In migration-is-failed case, we have to charge *old page* here.
> 
Ah... you are right.
Sorry for noise.


Daisuke Nishimura.

> >
> >I agree adding I/F would be good for future, but I think
> >mem_cgroup_charge_migration_fixup can be no-op function for now.
> >
> Hmm, handling failure case in explicit way may be better. Ok,
> I'll try some.
> 
> Thanks,
> -Kame
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 



