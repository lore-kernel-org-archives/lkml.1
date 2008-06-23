Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbYFWLTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbYFWLTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbYFWLTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:19:17 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:48058 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751484AbYFWLTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:19:16 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Greg KH <gregkh@suse.de>
Subject: Re: [patch 0/5] 2.6.25-stable review
Date: Mon, 23 Jun 2008 14:19:05 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
References: <20080622190111.GA20141@suse.de>
In-Reply-To: <20080622190111.GA20141@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806231419.08436.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg and -stable team;

22 Haz 2008 Paz tarihinde, Greg KH şunları yazmıştı: 
> Responses should be made by Tuesday, June 24, 18:00:00 UTC.  Anything
> received after that time might be too late.

Please consider following commit for -stable also, it definetly fixes a boot failure caused by reported opps

commit 1f6ef2342972dc7fd623f360f84006e2304eb935
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Jun 20 12:19:28 2008 -0700

    [watchdog] hpwdt: fix use of inline assembly

    The inline assembly in drivers/watchdog/hpwdt.c was incredibly broken,
    and included all the function prologue and epilogue stuff, even though
    it was itself then inside a C function where the compiler would add its
    own prologue and epilogue on top of it all.

    This then just _happened_ to work if you had exactly the right compiler
    version and exactly the right compiler flags, so that gcc just happened
    to not create any prologue at all (the gcc-generated epilogue wouldn't
    matter, since it would never be reached).

    But the more proper way to fix it is to simply not do this.  Move the
    inline asm to the top level, with no surrounding function at all (the
    better alternative would be to remove the prologue and make it actually
    use proper description of the arguments to the inline asm, but that's a
    bigger change than the one I'm willing to make right now).

    Tested-by: S.Çağlar Onur <caglar@pardus.org.tr>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
