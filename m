Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab0CHUCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:02:45 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:47267 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab0CHUCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:02:38 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: odd lockdep messages
In-Reply-To: Your message of "Mon, 08 Mar 2010 19:43:51 +0100."
             <1268073831.4997.69.camel@laptop>
From: Valdis.Kletnieks@vt.edu
References: <24605.1268073053@localhost>
            <1268073831.4997.69.camel@laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1268078410_3874P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 08 Mar 2010 15:00:10 -0500
Message-ID: <6025.1268078410@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4B95574C.011A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1268078410_3874P
Content-Type: text/plain; charset=us-ascii

On Mon, 08 Mar 2010 19:43:51 +0100, Peter Zijlstra said:
> On Mon, 2010-03-08 at 13:30 -0500, Valdis.Kletnieks@vt.edu wrote:
> > (Not sure when this started, just noticed it... Wasn't present in
> > 2.6.33-rc7-mmotm0210, is in 2.6.33-mmotm0302 and -mmotm0304).
> > 
> > Seen in dmesg:

> > [    1.012163] BUG: key ffff88011efbf500 not in .data!
> > [    1.012284] BUG: key ffff88011efbf548 not in .data!

> Can that be wreckage due to the new per-cpu stuff?
> 
> Its a message printed when the below function fails, and that per-cpu
> stuff seems the one most likely to break, given that there was quite a
> lot of churn in that department recently.

Would it make sense to stick some printk's on the 'return 1' cases

>         /*
>          * static variable?
>          */
>         if ((addr >= start) && (addr < end))
>                 return 1;
> 
>         if (arch_is_kernel_data(addr))
>                 return 1;
> 
> #ifdef CONFIG_SMP
>         /*
>          * percpu var?
>          */
>         for_each_possible_cpu(i) {
>                 start = (unsigned long) &__per_cpu_start + per_cpu_offset(i);
>                 end   = (unsigned long) &__per_cpu_start + PERCPU_ENOUGH_ROOM
>                                         + per_cpu_offset(i);
> 
>                 if ((addr >= start) && (addr < end))
>                         return 1;

or am I setting myself up for printk spam from hell if I do that?

--==_Exmh_1268078410_3874P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLlVdKcC3lWbTT17ARAjvPAJ9YfG8JU0KNtNx6lIsA6QFppNBMNACcDf0v
ytjRl0zXJKHhKn2CM1rt0k4=
=mUGu
-----END PGP SIGNATURE-----

--==_Exmh_1268078410_3874P--

