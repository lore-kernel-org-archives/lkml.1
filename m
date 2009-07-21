Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZGUGtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZGUGtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 02:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbZGUGtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 02:49:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40899 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbZGUGtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 02:49:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A6564F2.10404@jp.fujitsu.com>
Date: Tue, 21 Jul 2009 15:49:22 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>, Vivek Goyal <vgoyal@redhat.com>,
       Brayan Arraes <brayan@yack.com.br>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Subject: Re: [PATCH] sysrq, kdump: fix regression, revert "simplify sysrq-c
 handler"
References: <4A64672E.8020005@cn.fujitsu.com>
In-Reply-To: <4A64672E.8020005@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> 1) This fix breaks our tools.
>       This fix changes the ABI. panic_on_oops is default 0,
>    and a lots system do not specify the boot option "panic",
>    thus, Sysrq-c will not cause CrashDump(Kdump) as expected.
> 
> 2) When CONFIG_KEXEC=n, Sysrq-c should become an invalid
>    command like Sysrq-D(CONFIG_LOCKDEP, show-all-locks).
>    But this fix makes it a valid command and let it do a
>    hazard thing: cause a page fault(NULL dereference) in kernel.
> 
> So, we revert this fix.
> 
> |commit d6580a9f15238b87e618310c862231ae3f352d2d
> |Author: Neil Horman <nhorman@tuxdriver.com>
> |Date:   Wed Jun 17 16:28:17 2009 -0700
> 
> |    kexec: sysrq: simplify sysrq-c handler
> 
> |    Currently the sysrq-c handler is bit over-engineered.  Its behavior is
> |    dependent on a few compile time and run time factors that alter its
> |    behavior which is really unnecessecary.
> 
> |    If CONFIG_KEXEC is not configured, sysrq-c, crashes the system with a NULL
> |    pointer dereference.  If CONFIG_KEXEC is configured, it calls crash_kexec
> |    directly, which implies that the kexec kernel will either be booted (if
> |    its been previously loaded), or it will simply do nothing (the no kexec
> |    kernel has been loaded).
> 
> |    It would be much easier to just simplify the whole thing to dereference a
> |    NULL pointer all the time regardless of configuration.  That way, it will
> |    always try to crash the system, and if a kexec kernel has been loaded into
> |    reserved space, it will still boot from the page fault trap handler
> |    (assuming panic_on_oops is set appropriately).
> 
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---

FYI, this problem has already pointed by Ohmichi-san and this will be an
another patch for the following discussion:
  http://lists.infradead.org/pipermail/kexec/2009-July/003433.html
You can find my sloppy memo in:
  http://lists.infradead.org/pipermail/kexec/2009-July/003443.html

I agree with you that SysRq-'c' is well known as for 'C'rashdump, and it is
not expected as 'C'rash without dump.


Thanks,
H.Seto

