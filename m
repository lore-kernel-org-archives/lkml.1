Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab0CDPDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:03:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:32814 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab0CDPDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:03:43 -0500
Subject: Re: [GIT PULL] x86/mm fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "H. Peter Anvin" <hpa@linux.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sachin Sant <sachinp@in.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Alok Kataria <akataria@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Pasi =?ISO-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
In-Reply-To: <20100304004425.GA8035@localhost>
References: <201003020010.o220Ax3Z025848@hera.kernel.org>
	 <alpine.LFD.2.00.1003021038410.3616@localhost.localdomain>
	 <4B8D67A4.8080602@zytor.com> <20100303020845.GD6477@localhost>
	 <alpine.LFD.2.00.1003030909590.3627@localhost.localdomain>
	 <20100304004425.GA8035@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 16:03:35 +0100
Message-ID: <1267715015.25158.203.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 08:44 +0800, Wu Fengguang wrote:
> On Thu, Mar 04, 2010 at 01:10:46AM +0800, Linus Torvalds wrote:
> > 
> > 
> > On Wed, 3 Mar 2010, Wu Fengguang wrote:
> > > 
> > > Anyway I just hacked /usr/share/quilt/refresh to automatically run the
> > > kernel style checker:
> > > 
> > > # wfg: check for kernel coding style
> > > if [ -x scripts/checkpatch.pl ]; then
> > >         scripts/checkpatch.pl $patch_file
> > > fi
> > 
> > It's probably sensible to check things, but do remember that some of the 
> > things checkpatch warns about are better left the way they are, rather 
> > than make the code uglier just to make checkpatch happy.
> 
> OK. Here is the simple patch for quilt. I guess it may be hardly
> acceptable for quilt upstream, so only intends to share it here.

I use the below, which allows me to specify what to run on refresh time.

The script I have it use looks like:

$ cat /usr/local/bin/fix-patch.sh
TMP=`tempfile -d /tmp`
awk -f /usr/local/bin/fix-patch.awk $1 > $TMP
if [ -x ./scripts/checkpatch.pl ]; then
        ./scripts/checkpatch.pl $TMP
fi
mv $TMP $1


and fix-patch.awk does things like sanitize mail headers and add
Signed-off-by, lines.

---

--- /usr/share/quilt/refresh~	2008-06-22 00:43:27.000000000 +0200
+++ /usr/share/quilt/refresh	2008-05-28 12:45:27.789068034 +0200
@@ -278,6 +278,10 @@
 
 cat $tmp_patch >> $tmp_result
 
+if [ -n "$QUILT_REFRESH_EXT" ] ; then
+	$QUILT_REFRESH_EXT $tmp_result
+fi
+
 if [ -e $patch_file ] && \
    diff -q $patch_file $tmp_result > /dev/null
 then


