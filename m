Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbYLTVtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbYLTVtE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 16:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYLTVsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 16:48:53 -0500
Received: from 8bytes.org ([88.198.83.132]:52085 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbYLTVsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 16:48:52 -0500
Date: Sat, 20 Dec 2008 22:48:50 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Pavel Machek <pavel@suse.cz>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
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
Message-ID: <20081220214850.GB4465@8bytes.org>
References: <20081216235704.347182084@mini.kroah.org> <20081217000353.GB4504@kroah.com> <20081218130015.GA1420@ucw.cz> <20081219112137.GN3407@amd.com> <20081220112613.GA7480@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081220112613.GA7480@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 12:26:14PM +0100, Pavel Machek wrote:
> On Fri 2008-12-19 12:21:37, Joerg Roedel wrote:
> > So you don't consider lost data because your filesystem is corrupted
> > as a problem? This is exactly what can happen (and I suffered from it
> > one time) if you use IOMMU with a buggy driver (typically a network card
> > driver).
> 
> If you have buggy driver, _you have to fix the driver_, not work
> around it by iommu magic that only few machines can do.

If you can test and fix all possible drivers before maintenance of
2.6.27 ends this would be great. But I don't think this is realistic.
Before we can fix drivers the developers need ways to find those kind of
bugs (which have little or no impact if you use the nommu dma_ops driver).
Exactly for this reason I wrote the DMA API debugging patchset. With it
driver developers will be able to find most of those bugs. But fixing
them is surely not a thing which could be done in one kernel version
(All three network card drivers I tested with DMA API debugging code
 triggered errors).
So as long as not all drivers work correctly we have at least limit the
impact of driver bugs to the driver itself. This is done by making
device isolation the default.

> So this fixes nothing. (But it helps mask bugs in other pieces of
> code/hw. Good. But for stable?)

It does not mask the bugs, just limit the impact. The user will still
see the a WARN when a driver frees am address which is already free and
the user still get a message in dmesg when a device triggers an IO page
fault.

Joerg
