Return-Path: <linux-kernel-owner+w=401wt.eu-S1752217AbZHILZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbZHILZV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 07:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbZHILZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 07:25:20 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:33200 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502AbZHILZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 07:25:19 -0400
X-Trace: 243757297/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.122.97/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.122.97
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoFAK9OfkpPRXph/2dsb2JhbACBUssLhBgF
X-IronPort-AV: E=Sophos;i="4.43,348,1246834800"; 
   d="scan'208";a="243757297"
Date: Sun, 9 Aug 2009 12:24:57 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Ben Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_PREEMPT_RCU in next/mmotm
In-Reply-To: <20090809053308.GD6866@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0908091209150.23855@sister.anvils>
References: <Pine.LNX.4.64.0908081956580.12300@sister.anvils>
 <20090808235634.GB6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908090414320.18096@sister.anvils>
 <20090809053308.GD6866@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Aug 2009, Paul E. McKenney wrote:
> On Sun, Aug 09, 2009 at 04:32:28AM +0100, Hugh Dickins wrote:
> > 
> > Is there some particular attribute of a cpu, most relevant to its RCU
> > grace status, that I can check on with a printk?
> 
> The debugfs files enabled by CONFIG_RCU_TRACE, except rcu/rcugp, which,
> since it will attempt to wait for a grace period, will probably wait

Here's ten second samples from just before and after it "goes":
the number of filp objects (my own guide to it going), rcuctrs and
rctstats.  With ggp stuck on 35124, as you predicted, rcugp just hangs.

filp 5616 objects:

CPU last cur F M
  0    0   0 0 1
  1    0   0 0 0
  2    0  -1 0 0
  3    0   1 0 0
ggp = 33821, state = waitmb

na=2751281 nl=64 wa=2751217 wl=176 da=2751041 dl=0 dr=2751041 di=2751023
1=353642 e1=193343 i1=33939 ie1=118 g1=33821 a1=38041 ae1=4220 a2=33821
z1=36834 ze1=3013 z2=33821 m1=51485 me1=17665 m2=33820

filp 5780 objects:

CPU last cur F M
  0    0   0 0 0
  1    0   0 0 0
  2   -1   0 0 0
  3    1   0 0 0
ggp = 34518, state = waitack

na=2826191 nl=18 wa=2826173 wl=71 da=2826102 dl=0 dr=2826102 di=2826058
1=362636 e1=198972 i1=34640 ie1=122 g1=34518 a1=38847 ae1=4330 a2=34517
z1=37702 ze1=3185 z2=34517 m1=52475 me1=17958 m2=34517

filp 13343 objects:

CPU last cur F M
  0    1   0 0 0
  1    0   0 0 0
  2   -1   0 0 0
  3    0   0 0 0
ggp = 35124, state = waitzero

na=2898045 nl=15380 wa=2882665 wl=150 da=2882515 dl=0 dr=2882515 di=2882465
1=371717 e1=204532 i1=35248 ie1=124 g1=35124 a1=39545 ae1=4421 a2=35124
z1=39077 ze1=3954 z2=35123 m1=53315 me1=18192 m2=35123

filp 67190 objects:

CPU last cur F M
  0    1   0 0 0
  1    0   1 0 0
  2   -1   0 0 0
  3    0   0 0 0
ggp = 35124, state = waitzero

na=2961758 nl=79093 wa=2882665 wl=150 da=2882515 dl=0 dr=2882515 di=2882465
1=383301 e1=212065 i1=35248 ie1=124 g1=35124 a1=39545 ae1=4421 a2=35124
z1=43128 ze1=8005 z2=35123 m1=53315 me1=18192 m2=35123

filp 137160 objects:

CPU last cur F M
  0    1   1 0 0
  1    0   0 0 0
  2   -1   0 0 0
  3    0   0 0 0
ggp = 35124, state = waitzero

na=3041696 nl=159031 wa=2882665 wl=150 da=2882515 dl=0 dr=2882515 di=2882465
1=394717 e1=219335 i1=35248 ie1=124 g1=35124 a1=39545 ae1=4421 a2=35124
z1=47274 ze1=12151 z2=35123 m1=53315 me1=18192 m2=35123

Hugh
