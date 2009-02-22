Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbZBVJf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbZBVJf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 04:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbZBVJfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 04:35:16 -0500
Received: from fe01x03-cgp.akado.ru ([77.232.31.164]:53288 "EHLO akado.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752928AbZBVJfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 04:35:14 -0500
X-Greylist: delayed 3604 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Feb 2009 04:35:14 EST
Date: Sun, 22 Feb 2009 11:35:04 +0300 (MSK)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@linmac.oyster.ru
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: Lock-up on PPC64
In-Reply-To: <Pine.LNX.4.64.0901070105510.4695@linmac.oyster.ru>
Message-ID: <Pine.LNX.4.64.0902221126220.3111@linmac.oyster.ru>
References: <Pine.LNX.4.64.0812212058550.2164@linmac.oyster.ru>
 <20081222233223.GA6688@joi> <877i5rh9rm.fsf@linmac.oyster.ru>
 <20081223234513.GA8730@deepthought> <871vvy77v4.fsf@linmac.oyster.ru>
 <1230165163.7292.32.camel@pasglop> <Pine.LNX.4.64.0812280335070.2526@linmac.oyster.ru>
 <1231158516.8367.3.camel@localhost> <Pine.LNX.4.64.0901051928200.2208@linmac.oyster.ru>
 <1231243373.14860.24.camel@pasglop> <Pine.LNX.4.64.0901062032550.2972@linmac.oyster.ru>
 <1231276643.14860.30.camel@pasglop> <Pine.LNX.4.64.0901070105510.4695@linmac.oyster.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009, malc wrote:

> On Wed, 7 Jan 2009, Benjamin Herrenschmidt wrote:
> 
> > 
> > > As you wish :) I've written some ad-hoc stuff in the failing path which
> > > manually triggers sysrq and then sends the klogctl output via network
> > > and here it is:
> > 
> > Allright, something's unclear to me. What do you mean by the system goes
> > down then ? The kernel appears to be working at least to a certain
> > extent if you manage to trigger a sysrq from userspace... And from what
> > I see, it looks that all processes are somewhere in schedule.
> > 
> > So what is precisely your symptom here ?

After writing valgrind tool that was simulating Cell XER.SO syscall
(mis)behaviour (pre ab598b6680f1e74c267d1547ee352f3e1e530f89 that is)
and banging my had against the wall for a while trying to figure out
which of the failing syscalls was responsible, i've tried to be simple
and after only ~30 minutes came up with this, rather short, piece of
code that knocks pre XER.SO patched kernels out cold:

gcc -o xer -x assembler /dev/stdin -nostdlib <<eof
.globl _start
_start:
         addis 0,0,0x8000
         mtxer 0
         addi 0,0,1
         sc
eof

-- 
mailto:av1474@comtv.ru
