Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbZL0Ate@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbZL0Ate (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 19:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZL0Atd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 19:49:33 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:54766 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbZL0Atc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 19:49:32 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, joe@perches.com,
       torvalds@linux-foundation.org, peterz@infradead.org, efault@gmx.de,
       akpm@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [tip:sched/urgent] sched: Restore printk sanity
In-Reply-To: Your message of "Fri, 25 Dec 2009 19:45:14 +0100."
             <20091225184514.GA381@elte.hu>
From: Valdis.Kletnieks@vt.edu
References: <1261315437.4314.6.camel@laptop> <tip-6c9a74afc5d95321e33a727b3c563f3e7d6c4a5c@git.kernel.org> <20091225132642.GA1419@ucw.cz>
            <20091225184514.GA381@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1261874741_3923P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 26 Dec 2009 19:45:41 -0500
Message-ID: <5723.1261874741@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4B36AE36.019D,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1261874741_3923P
Content-Type: text/plain; charset=us-ascii

On Fri, 25 Dec 2009 19:45:14 +0100, Ingo Molnar said:

>  - in the last stable kernel, v2.6.32, still more new printk()s were 
>    introduced than pr_*() lines:
> 
>      $ git log -p v2.6.31..v2.6.32 | grep '^+.*\<pr_' | wc -l
>      2016
>      $ git log -p v2.6.31..v2.6.32 | grep '^+.*\<printk' | wc -l
>      3531

Ahem. That's not introduced, that's 'added or modified'.

% git log -p v2.6.31..v2.6.32 | grep -C 5 '^+.*\<pr_' | head
-        * In case of failure continue with no timer. */
+       /* Test if the external timer can be actually used.
+        * In case of failure continue without timer. */
        if (unlikely((stmmac_open_ext_timer(dev, priv->tm)) < 0)) {
-               pr_warning("stmmaceth: cannot attach the HW timer\n");
+               pr_warning("stmmaceth: cannot attach the external timer.\n");
                tmrate = 0;
                priv->tm->freq = 0;
                priv->tm->timer_start = stmmac_no_timer_started;
                priv->tm->timer_stop = stmmac_no_timer_stopped;

Meanwhile, the fact that there's only about a 2-to-1 difference in patches when
there's a 6-to-1 difference in existing code tells me that proportionally,
there is *more* activity with pr_foo variants than printk.

printk:  3531 hits in 61126 uses = 5.7% churn
pr_foo: 2016 hits in 10861 uses = 18.5% churn

The numbers need much deeper analysis to make any sort of real statistical
conclusion here...

> 
> An estimated completion of the 'conversion' to pr_*() to be in infinite numbe
r 
> of years.
> 
> > [...] just removing the "sched:" would be better for consistency.
> > 
> > Or alternatively... deprecate pr_*?
> 
> Or alternatively, my favorite: let people who write the code use whichever 
> variant they prefer.
> 
> 	Ingo


--==_Exmh_1261874741_3923P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLNq40cC3lWbTT17ARArDFAJ9l17o2ldMNtss2JYbbncKAQSps6gCg8mSJ
5ChhTNcTdFozBD1TRg38Fp0=
=p9cX
-----END PGP SIGNATURE-----

--==_Exmh_1261874741_3923P--

