Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYKUPex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYKUPex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbYKUPeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:34:44 -0500
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1125 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYKUPen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:34:43 -0500
Date: Fri, 21 Nov 2008 16:34:26 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.28-rc5] RCU detected CPU 0 stall (t=4294893165/750
	jiffies)
Message-ID: <20081121153425.GR24427@vanheusden.com>
References: <20081119123717.GE24427@vanheusden.com> <49267FA4.60609@cn.fujitsu.com> <20081121094543.GP24427@vanheusden.com> <20081121151205.GA6775@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121151205.GA6775@linux.vnet.ibm.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Thu Nov 20 11:27:06 CET 2008
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm afraid there's no script for that: it happens during boot.
> 
> This is a HZ=250 machine, correct?  If so, please try the following
> patch (already in -tip), which helps suppress boot-time false positives.

That's correct, 250Hz.

> diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
> index 5f89b62..301dda8 100644
> --- a/include/linux/rcuclassic.h
> +++ b/include/linux/rcuclassic.h
> @@ -41,7 +41,7 @@
>  #include <linux/seqlock.h>
>  
>  #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
> -#define RCU_SECONDS_TILL_STALL_CHECK	( 3 * HZ) /* for rcp->jiffies_stall */
> +#define RCU_SECONDS_TILL_STALL_CHECK	(10 * HZ) /* for rcp->jiffies_stall */

Isn't it better to let the define depend on the value of CONFIG_HZ?
E.g.

Signed-off-by: Folkert van Heusden <folkert@vanheusden.com>

diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 5f89b62..301dda8 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -41,7 +41,7 @@
 #include <linux/seqlock.h>
 
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-#define RCU_SECONDS_TILL_STALL_CHECK	( 3 * HZ) /* for rcp->jiffies_stall */
+#define RCU_SECONDS_TILL_STALL_CHECK	( (CONFIG_HZ / 100) * 3 * HZ) /* for rcp->jiffies_stall */
 #define RCU_SECONDS_TILL_STALL_RECHECK	(30 * HZ) /* for rcp->jiffies_stall */
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */


Folkert van Heusden

-- 
MultiTail na wan makriki wrokosani fu tan luku den logfile nanga san
den commando spiti puru. Piki puru spesrutu sani, wroko nanga difrenti
kroru, tya kon makandra, nanga wan lo moro.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
