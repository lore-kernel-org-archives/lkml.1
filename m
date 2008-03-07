Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbYCGIfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbYCGIfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYCGIe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:34:56 -0500
Received: from www.tglx.de ([62.245.132.106]:39166 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbYCGIez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:34:55 -0500
Date: Fri, 7 Mar 2008 09:34:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
In-Reply-To: <3450.1204878180@turing-police.cc.vt.edu>
Message-ID: <alpine.LFD.1.00.0803070931470.3099@apollo.tec.linutronix.de>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <10815.1204862325@turing-police.cc.vt.edu> <20080306221602.790cd26e.akpm@linux-foundation.org> <4954.1204876349@turing-police.cc.vt.edu>            <alpine.LFD.1.00.0803070857360.3099@apollo.tec.linutronix.de>
 <3450.1204878180@turing-police.cc.vt.edu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, Valdis.Kletnieks@vt.edu wrote:

> On Fri, 07 Mar 2008 09:06:59 +0100, Thomas Gleixner said:
> > On Fri, 7 Mar 2008, Valdis.Kletnieks@vt.edu wrote:
> > > On Thu, 06 Mar 2008 22:16:02 PST, Andrew Morton said:
> > > > > [   74.254402] CPU 1 is now offline
> > > > > [   74.255395] SMP alternatives: switching to UP code
> > > > > [   74.256373] BUG: unable to handle kernel paging request at ffffffff8020a023
> > 
> > Can you decode ffffffff8020a023 via addr2line please ?
> 
> It's been a long day, and I couldn't get addr2line to work, it kept saying '??:0'.
> 
> However, this is in my System.map:
> 
> ffffffff8020a000 t poll_idle
> ffffffff8020a009 t do_nothing
> ffffffff8020a00f T set_personality_64bit
> ffffffff8020a041 T release_thread
> ffffffff8020a07d T arch_randomize_brk
> 
> so set_personality_64bit+0x14 or so?

Yeah. Sorry for making you do useless work. The meat is here:

> > [   74.256373] PGD 203067 PUD 207063 PMD 7e4cc163 PTE 20a161

----------------------------------------------------------^^^^^^

The PTE has the RW bit cleared, so the fault is not a big surprise.

Thanks,
	tglx
