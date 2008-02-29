Return-Path: <linux-kernel-owner+w=401wt.eu-S1761008AbYB2AKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761008AbYB2AKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYB2AKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:10:40 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:41068 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbYB2AKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:10:39 -0500
Date: Thu, 28 Feb 2008 16:09:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] kernel-doc: set verbose mode via environment
Message-Id: <20080228160920.c66c7b88.randy.dunlap@oracle.com>
In-Reply-To: <20080228183234.GA24684@uranus.ravnborg.org>
References: <20080224175358.3202f0d0.randy.dunlap@oracle.com>
	<20080227191104.6f166972.akpm@linux-foundation.org>
	<20080228083009.5955a7eb.randy.dunlap@oracle.com>
	<20080228183234.GA24684@uranus.ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008 19:32:34 +0100 Sam Ravnborg wrote:

> On Thu, Feb 28, 2008 at 08:30:09AM -0800, Randy Dunlap wrote:
> > On Wed, 27 Feb 2008 19:11:04 -0800 Andrew Morton wrote:
> > 
> > > On Sun, 24 Feb 2008 17:53:58 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > 
...
> > > 
> > > Shouldn't this be, err, documented somewhere?
> > 
> > I did think about that.  I was still wondering where to add it.
> In the same file where you document all the kconfig stuff - so we can let it be
> a 'all build features ' document?

Which "same file" is that?


> > > I'd have expected to obtain this functionality by running `make V=1 foodocs'?
> > 
> > Sam, any thoughts on Makefile passing "-v" to scripts/kernel-doc ?
> Please implemnt this. Either add a flag to docproc or
> just read the env-variable KBUILD_VERBOSE in kernel-doc.

Sure, I'll change /KERNEL_DOC_VERBOSE/ to /KBUILD_VERBOSE/ in
scripts/kernel-doc.  docproc doesn't need to be involved,
especially since scripts/kernel-doc is easily usable without docproc.

That also means that I can just use the existing KBUILD_VERBOSE
documentation.  :)

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Honor the environment variable "KBUILD_VERBOSE=1" (as set by
make V=1) to enable verbose mode in scripts/kernel-doc.  Useful for
getting more info and warnings from kernel-doc.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-2625-rc3-kdoc.orig/scripts/kernel-doc
+++ linux-2625-rc3-kdoc/scripts/kernel-doc
@@ -247,6 +247,10 @@ my ($function, %function_table,%paramete
 my ($type,$declaration_name,$return_type);
 my ($newsection,$newcontents,$prototype,$filelist, $brcount, %source_map);
 
+if (defined($ENV{'KBUILD_VERBOSE'})) {
+	$verbose = "$ENV{'KBUILD_VERBOSE'}";
+}
+
 # Generated docbook code is inserted in a template at a point where
 # docbook v3.1 requires a non-zero sequence of RefEntry's; see:
 # http://www.oasis-open.org/docbook/documentation/reference/html/refentry.html

