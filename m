Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0BQKkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 05:40:10 -0500
Received: from mail-gw2.cc.tut.fi ([130.230.160.16]:42386 "EHLO
	mail-gw2.cc.tut.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0BQKkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 05:40:08 -0500
X-AuditID: 82e6a010-b7b29ae000000a5e-b1-4b7bc4009a2c
Date: Wed, 17 Feb 2010 12:25:04 +0200
From: Petri Kaukasoina <kaukasoina907m57kr9@sci.fi>
To: Willy Tarreau <w@1wt.eu>
Cc: James Cloos <cloos@jhcloos.com>, Jean Delvare <khali@linux-fr.org>,
       lasse.collin@tukaani.org, Phillip Lougher <phillip@lougher.demon.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100217102504.GA15365@elektroni.phys.tut.fi>
Mail-Followup-To: Willy Tarreau <w@1wt.eu>, James Cloos <cloos@jhcloos.com>,
	Jean Delvare <khali@linux-fr.org>, lasse.collin@tukaani.org,
	Phillip Lougher <phillip@lougher.demon.co.uk>,
	linux-kernel <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
	users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
	Pavel Machek <pavel@ucw.cz>
References: <4B744E13.8040004@kernel.org> <20100211205129.GA26105@elf.ucw.cz> <20100213181008.479509f5@hyperion.delvare> <4B773B31.1020802@lougher.demon.co.uk> <20100214102308.1d1d6fff@hyperion.delvare> <20100214094940.GB17999@1wt.eu> <m3wrye9od4.fsf@lugabout.jhcloos.org> <20100217054047.GF18216@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100217054047.GF18216@1wt.eu>
User-Agent: Mutt/1.4.2.3i
X-Brightmail-Tracker: AAAAARLTyl8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 06:40:47AM +0100, Willy Tarreau wrote:
> On Mon, Feb 15, 2010 at 04:31:59PM -0500, James Cloos wrote:
> > >>>>> "W" == Willy Tarreau <w@1wt.eu> writes:
> > 
> > W> Well, I personally like to be able to simply run "less patch-2.6.27.45.gz"
> > W> and have it transparently uncompressed and dumped on my terminal. It
> > W> doesn't do that on bz2. We could find multiple examples.
> > 
> > It does here, and lzma & xz, too.  And has since just days after Lasse
> > annouced that the new name would be xz.
> > 
> > Your LESSOPEN controls that, and can be easily coded to support any archive.
> 
> Just checked and I found it funny to see that patch-2.6.1.bz2 is not
> correctly opened while 2.6.27.45.bz2 is.


There is a bug in lesspipe.sh, at least here. It confuses it with compresses
man pages.

--- lesspipe.sh~        2009-11-06 02:14:58.000000000 +0200
+++ lesspipe.sh 2010-02-17 12:19:09.000000000 +0200
@@ -50,6 +50,7 @@

*.1.bz2|*.2.bz2|*.3.bz2|*.4.bz2|*.5.bz2|*.6.bz2|*.7.bz2|*.8.bz2|*.9.bz2|*.n.bz2|*.man.bz2)
# compressed *roff src?
     if bzip2 -dc "$1" | file - | grep roff 1> /dev/null ; then
       bzip2 -dc "$1" | nroff -S -mandoc -
+    else bzip2 -dc "$1"  2>/dev/null
     fi ;;
   *.gz) gzip -dc "$1"  2>/dev/null ;;
   *.bz2) bzip2 -dc "$1" 2>/dev/null ;;
