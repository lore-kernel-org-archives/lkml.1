Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbYAVMjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbYAVMjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 07:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbYAVMjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 07:39:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbYAVMjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 07:39:11 -0500
Date: Tue, 22 Jan 2008 10:34:50 -0200
From: Eduardo Pereira Habkost <ehabkost@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com
Subject: Re: [PATCH 0/4] paravirt_ops-64 compile fixes
Message-ID: <20080122123450.GU7338@blackpad>
References: <1200952133-31581-1-git-send-email-ehabkost@redhat.com> <20080122120207.GA30271@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122120207.GA30271@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 01:02:07PM +0100, Ingo Molnar wrote:
> 
> * Eduardo Habkost <ehabkost@redhat.com> wrote:
> 
> > This series contain fixes to make the paravirt_ops code compile and 
> > boot on x86_64.
> > 
> > This is a follow-up for the previous series from Glauber.
> 
> thanks Eduardo, i've applied your fixes.
> 
> could you perhaps send the missing bits that add the missing 64-bit 
> Kconfig entries? Even if the 64-bit side is not functional yet as a real 
> guest, it would help us find the build bugs and any runtime regressions 
> PARAVIRT might cause on the native 64-bit side of the kernel.
> 
> Or is it now just a matter of removing all the depends-on X86_32 bits in 
> arch/x86/Kconfig?

Removing the depends won't be enough because CONFIG_PARAVIRT won't be
selected unless one of Xen, VMI, or lguest is selected. (PARAVIRT is
not visible on menuconfig, only PARAVIRT_GUEST, that doesn't enable any
code).

When hacking, I remove the 32-bit depends and add "select PARAVIRT" to
"menuconfig PARAVIRT_GUEST".

I think neither of the three guest implementations are ready for 64-bit
yet. I am working on Xen and it is far from being ready for inclusion. I
don't know about VMI and lguest.

If this is desirable for broader testing, we can make config PARAVIRT
visible and selectable on menuconfig, even when there is no guest
implementation being enabled. Should I do it?

Maybe should this force-paravirt mode be a kernel debugging option?

-- 
Eduardo
