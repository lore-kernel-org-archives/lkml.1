Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179AbYL0KgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbYL0KgQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 05:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbYL0Kf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 05:35:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36446 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbYL0Kf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 05:35:59 -0500
Date: Sat, 27 Dec 2008 11:35:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org, ralf@linux-mips.org, kernel@wantstofly.org,
       hskinnemoen@atmel.com, cooloney@kernel.org, tony.luck@intel.com,
       geert@linux-m68k.org, zippel@linux-m68k.org, jwboyer@linux.vnet.ibm.com,
       mporter@kernel.crashing.org, grant.likely@secretlab.ca,
       paulus@samba.org, benh@kernel.crashing.org, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com, lethal@linux-sh.org, hpa@zytor.com
Subject: Re: [PATCH, -tip] Make hierarchical RCU be the default
Message-ID: <20081227103501.GG14639@elte.hu>
References: <1229991147545-git-send-email-paulmck@linux.vnet.ibm.com> <12299911471985-git-send-email-paulmck@linux.vnet.ibm.com> <20081223142542.GC29151@elte.hu> <20081223215948.GA16137@linux.vnet.ibm.com> <20081223220345.GA16472@linux.vnet.ibm.com> <20081223220648.GB16472@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081223220648.GB16472@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -118,7 +118,7 @@ static inline void account_system_vtime(struct task_struct *tsk)
>  }
>  #endif
>  
> -#if defined(CONFIG_NO_HZ) && !defined(CONFIG_CLASSIC_RCU)
> +#if defined(CONFIG_NO_HZ) && !defined(CONFIG_FLAT_RCU)

this can be done in an even lazier fashion, via a ~5 lines patch.

Just add FLAT_RCU as the new kconfig method, and make CONFIG_CLASSIC_RCU 
mirror it via something like:

  config CLASSIC_RCU
  bool
  default FLAT_RCU

that makes your patch only affect the Kconfig file - and makes it easily 
revertable, etc.

	Ingo
