Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbYLTLc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbYLTLc1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 06:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYLTLcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 06:32:19 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51687 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYLTLcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 06:32:18 -0500
Date: Sat, 20 Dec 2008 12:26:14 +0100
From: Pavel Machek <pavel@suse.cz>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 01/22] AMD IOMMU: enable device isolation per default
Message-ID: <20081220112613.GA7480@ucw.cz>
References: <20081216235704.347182084@mini.kroah.org> <20081217000353.GB4504@kroah.com> <20081218130015.GA1420@ucw.cz> <20081219112137.GN3407@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081219112137.GN3407@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-12-19 12:21:37, Joerg Roedel wrote:
> On Thu, Dec 18, 2008 at 02:00:15PM +0100, Pavel Machek wrote:
> > On Tue 2008-12-16 16:03:53, Greg KH wrote:
> > > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > > 
> > > ------------------
> > > 
> > > From: Joerg Roedel <joerg.roedel@amd.com>
> > > 
> > > commit 3ce1f93c6d53c3f91c3846cf66b018276c8ac2e7 upstream.
> > > 
> > > Impact: makes device isolation the default for AMD IOMMU
> > > 
> > > Some device drivers showed double-free bugs of DMA memory while testing
> > > them with AMD IOMMU. If all devices share the same protection domain
> > > this can lead to data corruption and data loss. Prevent this by putting
> > > each device into its own protection domain per default.
> > > 
> > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > This does not look like 'fix for a serious bug' to
> > me. stable_kernel_rules.txt says '...not a "this could be a problem"
> > type thing'.
> 
> So you don't consider lost data because your filesystem is corrupted
> as a problem? This is exactly what can happen (and I suffered from it
> one time) if you use IOMMU with a buggy driver (typically a network card
> driver).

If you have buggy driver, _you have to fix the driver_, not work
around it by iommu magic that only few machines can do.

So this fixes nothing. (But it helps mask bugs in other pieces of
code/hw. Good. But for stable?)

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
