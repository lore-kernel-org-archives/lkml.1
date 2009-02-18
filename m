Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbZBRBml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbZBRBml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbZBRBlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:41:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756700AbZBRBlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:41:03 -0500
Date: Tue, 17 Feb 2009 17:40:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-02-17-12-33 uploaded (nr_pdflush_threads_min sysctl
 build error)
Message-Id: <20090217174054.c67a75d5.akpm@linux-foundation.org>
In-Reply-To: <499B5BE1.60003@oracle.com>
References: <200902172050.n1HKorvc028933@imap1.linux-foundation.org>
	<499B5BE1.60003@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009 16:52:49 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-02-17-12-33 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> 
> 
> Is there any CONFIG_ symbol associated with $subject sysctl?

Nope.

> 'one' is only available (currently) when:
> 
> #if defined(CONFIG_DETECT_HUNG_TASK) || defined(CONFIG_DETECT_SOFTLOCKUP) || defined(CONFIG_HIGHMEM)
> static int one = 1;
> #endif
> 
> so it gives us
> kernel/sysctl.c:1067: error: 'one' undeclared here (not in a function)
> 
> when one of those is not #defined.

OK, thanks.

--- a/kernel/sysctl.c~mm-add-proc-controls-for-pdflush-threads-fix-99
+++ a/kernel/sysctl.c
@@ -91,10 +91,7 @@ extern int sysctl_nr_trim_pages;
 extern int rcutorture_runnable;
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
-/* Constants used for minimum and  maximum */
-#if defined(CONFIG_DETECT_HUNG_TASK) || defined(CONFIG_DETECT_SOFTLOCKUP) || defined(CONFIG_HIGHMEM)
-static int one = 1;
-#endif
+/* Constants used for minimum and maximum */
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 static int sixty = 60;
 static int neg_one = -1;
@@ -105,6 +102,7 @@ static int two = 2;
 #endif
 
 static int zero;
+static int one = 1;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
 static int one_thousand = 1000;
diff -puN mm/pdflush.c~mm-add-proc-controls-for-pdflush-threads-fix-99 mm/pdflush.c
_

