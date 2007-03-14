Return-Path: <linux-kernel-owner+w=401wt.eu-S1750988AbXCNRwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750988AbXCNRwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbXCNRwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:52:18 -0400
Received: from main.gmane.org ([80.91.229.2]:55224 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbXCNRwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:52:17 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>
Subject: Re: [Bug 8040] Hang before INIT when =?utf-8?b?Q09ORklHX0hJR0hNRU00Rz15?= [Fix =?utf-8?b?Q09ORklHX0NPTVBBVF9WRFNPXQ==?= <- Bad
Date: Wed, 14 Mar 2007 17:52:01 +0000 (UTC)
Message-ID: <loom.20070314T184515-284@post.gmane.org>
References: <200703141013.l2EADP6c027144@fire-2.osdl.org>  <20070314041710.770708c4.akpm@linux-foundation.org> <6bffcb0e0703140430i2202f14dw1681d5c70c1d4e28@mail.gmail.com> <loom.20070314T131349-236@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 145.9.150.34 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20060601 Firefox/2.0.0.2 (Ubuntu-edgy))
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Leroy van Logchem <leroy.vanlogchem <at> wldelft.nl> writes:

> 
> > > None whatsoever.  Three people are reporting this and it's a drop-dead
> > > showstopper for a 2.6.21 release so we just have to wait until someone
> > > wakes up and thinks about it.
> 
> The topic should be "when CONFIG_HIGHMEM64G=y" imo.
> 
> I'll try to do my first bi-sect today.

Bisecting went well, after 13 compiles this commit was found:

a1f3bb9ae4497a2ed3eac773fd7798ac33a0371f is first bad commit
commit a1f3bb9ae4497a2ed3eac773fd7798ac33a0371f
Author: Roland McGrath <roland@redhat.com>
Date:   Fri Jan 26 00:56:46 2007 -0800

    [PATCH] Fix CONFIG_COMPAT_VDSO
    
    I wouldn't mind if CONFIG_COMPAT_VDSO went away entirely.  But if it's there,
    it should work properly.  Currently it's quite haphazard: both real vma and
    fixmap are mapped, both are put in the two different AT_* slots, sysenter
    returns to the vma address rather than the fixmap address, and core dumps yet
    are another story.
    
    This patch makes CONFIG_COMPAT_VDSO disable the real vma and use the fixmap
    area consistently.  This makes it actually compatible with what the old vdso
    implementation did.
    
    Signed-off-by: Roland McGrath <roland@redhat.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Cc: Andi Kleen <ak@suse.de>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 802ab3366a651ecba28c8677fa84a9f7c506392b
f44adc4dcdab733e5965b68ccd0d643f0a550a80 M      arch
:040000 040000 be1e217152d8b3fcd05f09aa2b3f4f9dcb8208aa
46cc86427e861350dd3fef9469474c55119f27ce M      include

I had both CONFIG_COMPAT_VDSO=y and CONFIG_HIGHMEM64G=y configured.
Using a 4GB Supermicro 7044 SMP dual Xeon. Details upon request.

--
Leroy

