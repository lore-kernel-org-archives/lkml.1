Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbZHGABr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbZHGABr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 20:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbZHGABq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 20:01:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51657 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756599AbZHGABq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 20:01:46 -0400
Date: Thu, 6 Aug 2009 20:01:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Greg KH <gregkh@suse.de>, Roland Dreier <rdreier@cisco.com>,
       Matt Fleming <matt@console-pimps.org>,
       David Kiliani <mail@davidkiliani.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL][2.6.31] tracing: have recordmcount.pl handle a section
 with only weak functions
In-Reply-To: <20090806233208.GA29339@suse.de>
Message-ID: <alpine.DEB.2.00.0908062000400.2840@gandalf.stny.rr.com>
References: <ada4oskfwtp.fsf@cisco.com> <alpine.DEB.2.00.0908061745430.2840@gandalf.stny.rr.com> <20090806222906.GA14792@suse.de> <alpine.DEB.2.00.0908061844300.2840@gandalf.stny.rr.com> <alpine.DEB.2.00.0908061849260.2840@gandalf.stny.rr.com>
 <adamy6ceeig.fsf@cisco.com> <20090806233208.GA29339@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Steven Rostedt (1):
      tracing: have recordmcount.pl handle a section with only weak functions

----
 scripts/recordmcount.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
---------------------------
commit 0484219980fd985528f66bf620362859e617bb37
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Aug 6 19:53:18 2009 -0400

    tracing: have recordmcount.pl handle a section with only weak functions
    
    Roland Dreier found that a section that contained only a weak function
    in one of the staging drivers and this caused recordmcount.pl to spit
    out a warning and fail.  Although it is strange that a driver would have
    a weak function, and this function only be used in one place, it should
    not be something to make recordmcount.pl fail.
    
    This patch fixes the issue in a simple manner. If only weak functions
    exist in a section, than that section will not be recorded.
    
    Reported-by: Roland Dreier <rdreier@cisco.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 4889c44..911ba7f 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -393,7 +393,7 @@ while (<IN>) {
 	    $read_function = 0;
 	}
 	# print out any recorded offsets
-	update_funcs() if ($text_found);
+	update_funcs() if (defined($ref_func));
 
 	# reset all markers and arrays
 	$text_found = 0;
@@ -444,7 +444,7 @@ while (<IN>) {
 }
 
 # dump out anymore offsets that may have been found
-update_funcs() if ($text_found);
+update_funcs() if (defined($ref_func));
 
 # If we did not find any mcount callers, we are done (do nothing).
 if (!$opened) {


