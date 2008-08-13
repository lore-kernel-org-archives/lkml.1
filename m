Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbYHMDOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbYHMDOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 23:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbYHMDOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 23:14:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54188 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbYHMDOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 23:14:41 -0400
Date: Tue, 12 Aug 2008 23:10:44 -0400
From: Dave Jones <davej@redhat.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [WATCHDOG] v2.6.27-rc patches
Message-ID: <20080813031044.GA11258@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Wim Van Sebroeck <wim@iguana.be>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20080806202918.GA29386@infomag.infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806202918.GA29386@infomag.infomag.iguana.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 10:29:18PM +0200, Wim Van Sebroeck wrote:
 > Hi Linus,
 > 
 > Please pull from 'master' branch of
 > 	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
 > or if master.kernel.org hasn't synced up yet:
 > 	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
 > 
 > This will update the following files:
 > 
 > Author: Anton Vorontsov <avorontsov@ru.mvista.com>
 > Date:   Thu Jul 3 23:51:36 2008 -0700
 > 
 >     [WATCHDOG] mpc8xxx_wdt: add support for MPC8xx watchdogs

This is broken when built modular because this...

 > +}
 > +module_init(mpc8xxx_wdt_init_late);

and this ..

 > +arch_initcall(mpc8xxx_wdt_init);

Can't be mixed.  You end up with two init_module invocations

drivers/watchdog/mpc8xxx_wdt.c:304: error: redefinition of '__inittest'
drivers/watchdog/mpc8xxx_wdt.c:298: error: previous definition of '__inittest' was here
drivers/watchdog/mpc8xxx_wdt.c:304: error: redefinition of 'init_module'
drivers/watchdog/mpc8xxx_wdt.c:298: error: previous definition of 'init_module' was here

Given they both call different routines though, I'm not sure the right fix here.

	Dave


-- 
http://www.codemonkey.org.uk
