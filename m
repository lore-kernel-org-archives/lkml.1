Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab0CEBIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 20:08:07 -0500
Received: from mga14.intel.com ([143.182.124.37]:50221 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab0CEBIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 20:08:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,584,1262592000"; 
   d="scan'208";a="251060770"
Date: Fri, 5 Mar 2010 09:07:59 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
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
       Pasi =?utf-8?B?S8Okcmtrw6RpbmVu?= <pasik@iki.fi>
Subject: Re: [GIT PULL] x86/mm fixes
Message-ID: <20100305010759.GA7998@localhost>
References: <201003020010.o220Ax3Z025848@hera.kernel.org> <alpine.LFD.2.00.1003021038410.3616@localhost.localdomain> <4B8D67A4.8080602@zytor.com> <20100303020845.GD6477@localhost> <alpine.LFD.2.00.1003030909590.3627@localhost.localdomain> <20100304004425.GA8035@localhost> <1267715015.25158.203.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267715015.25158.203.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 11:03:35PM +0800, Peter Zijlstra wrote:
> On Thu, 2010-03-04 at 08:44 +0800, Wu Fengguang wrote:
> > On Thu, Mar 04, 2010 at 01:10:46AM +0800, Linus Torvalds wrote:
> > > 
> > > 
> > > On Wed, 3 Mar 2010, Wu Fengguang wrote:
> > > > 
> > > > Anyway I just hacked /usr/share/quilt/refresh to automatically run the
> > > > kernel style checker:
> > > > 
> > > > # wfg: check for kernel coding style
> > > > if [ -x scripts/checkpatch.pl ]; then
> > > >         scripts/checkpatch.pl $patch_file
> > > > fi
> > > 
> > > It's probably sensible to check things, but do remember that some of the 
> > > things checkpatch warns about are better left the way they are, rather 
> > > than make the code uglier just to make checkpatch happy.
> > 
> > OK. Here is the simple patch for quilt. I guess it may be hardly
> > acceptable for quilt upstream, so only intends to share it here.
> 
> I use the below, which allows me to specify what to run on refresh time.
> 
> The script I have it use looks like:
> 
> $ cat /usr/local/bin/fix-patch.sh
> TMP=`tempfile -d /tmp`
> awk -f /usr/local/bin/fix-patch.awk $1 > $TMP
> if [ -x ./scripts/checkpatch.pl ]; then
>         ./scripts/checkpatch.pl $TMP

FYI, I added "-q" to checkpatch.pl to shut it up when patch is OK.

> fi
> mv $TMP $1
> 
> 
> and fix-patch.awk does things like sanitize mail headers and add
> Signed-off-by, lines.

Nice tool. Can you share fix-patch.awk? Thanks!

Regards,
Fengguang

> ---
> 
> --- /usr/share/quilt/refresh~	2008-06-22 00:43:27.000000000 +0200
> +++ /usr/share/quilt/refresh	2008-05-28 12:45:27.789068034 +0200
> @@ -278,6 +278,10 @@
>  
>  cat $tmp_patch >> $tmp_result
>  
> +if [ -n "$QUILT_REFRESH_EXT" ] ; then
> +	$QUILT_REFRESH_EXT $tmp_result
> +fi
> +
>  if [ -e $patch_file ] && \
>     diff -q $patch_file $tmp_result > /dev/null
>  then
> 
> 
