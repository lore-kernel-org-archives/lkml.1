Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbYCXVWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbYCXVWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 17:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYCXVWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 17:22:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:26017 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbYCXVWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 17:22:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,548,1199692800"; 
   d="scan'208";a="264707141"
Date: Mon, 24 Mar 2008 14:22:35 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: venkatesh.pallipadi@intel.com, ak@muc.de, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 02/13] x86: PAT infrastructure patch
Message-ID: <20080324212235.GA6783@linux-os.sc.intel.com>
References: <20080319000012.439150000@intel.com> <20080319000058.541493000@intel.com> <20080319130639.819777b7.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319130639.819777b7.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 01:06:39PM -0700, Randy Dunlap wrote:
> On Tue, 18 Mar 2008 17:00:14 -0700 venkatesh.pallipadi@intel.com wrote:
> 
> diffstat would be very nice to have.

I have updated my quilt scripts to auto-generate diffstat for any future
patches.

> 
> 
> > Index: linux-2.6-x86.git/arch/x86/Kconfig
> > ===================================================================
> > --- linux-2.6-x86.git.orig/arch/x86/Kconfig	2008-03-17 11:06:47.000000000 -0700
> > +++ linux-2.6-x86.git/arch/x86/Kconfig	2008-03-17 11:06:51.000000000 -0700
> > @@ -1013,6 +1013,21 @@
> >  
> >  	  See <file:Documentation/mtrr.txt> for more information.
> >  
> > +config X86_PAT
> > +	def_bool y
> > +	prompt "x86 PAT support"
> > +	depends on MTRR && NONPROMISC_DEVMEM
> > +	help
> > +	  Use PAT attributes to setup page level cache control.
> > +	---help---
> > +	  PATs are the modern equivalents of MTRRs and are much more
> > +	  flexible than MTRRs.
> > +
> 
> Do 2 help sections actually work?  We don't usually do that.
> Just change the second one to a blank line.
> 
> > +	  Say N here if you see bootup problems (boot crash, boot hang,
> > +	  spontaneous reboots) or a non-working Xorg.
> 
> Maybe "a non-working Xorg video driver" ?
> or even omit Xorg and just say video driver?
> 

Done with below patch.
Ingo: Please apply.

Thanks,
Venki




Fix double help section in PAT Kconfig. Thanks to Randy Dunlap for catching
this bug.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-x86.git/arch/x86/Kconfig
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/Kconfig	2008-03-21 08:28:47.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/Kconfig	2008-03-24 07:19:35.000000000 -0700
@@ -1019,12 +1019,12 @@ config X86_PAT
 	depends on MTRR && NONPROMISC_DEVMEM
 	help
 	  Use PAT attributes to setup page level cache control.
-	---help---
+
 	  PATs are the modern equivalents of MTRRs and are much more
 	  flexible than MTRRs.
 
 	  Say N here if you see bootup problems (boot crash, boot hang,
-	  spontaneous reboots) or a non-working Xorg.
+	  spontaneous reboots) or a non-working video driver.
 
 	  If unsure, say Y.
 
