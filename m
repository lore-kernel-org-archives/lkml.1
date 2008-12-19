Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbYLSLWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbYLSLWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 06:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYLSLVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 06:21:54 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:6194 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbYLSLVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 06:21:53 -0500
X-BigFish: VPS-38(zz1432R98dR936eQ1805M936fOzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KC4FK1-03-AK7-01
Date: Fri, 19 Dec 2008 12:21:37 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Pavel Machek <pavel@suse.cz>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
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
Message-ID: <20081219112137.GN3407@amd.com>
References: <20081216235704.347182084@mini.kroah.org> <20081217000353.GB4504@kroah.com> <20081218130015.GA1420@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081218130015.GA1420@ucw.cz>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Dec 2008 11:21:37.0400 (UTC) FILETIME=[F5087F80:01C961CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 02:00:15PM +0100, Pavel Machek wrote:
> On Tue 2008-12-16 16:03:53, Greg KH wrote:
> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Joerg Roedel <joerg.roedel@amd.com>
> > 
> > commit 3ce1f93c6d53c3f91c3846cf66b018276c8ac2e7 upstream.
> > 
> > Impact: makes device isolation the default for AMD IOMMU
> > 
> > Some device drivers showed double-free bugs of DMA memory while testing
> > them with AMD IOMMU. If all devices share the same protection domain
> > this can lead to data corruption and data loss. Prevent this by putting
> > each device into its own protection domain per default.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> This does not look like 'fix for a serious bug' to
> me. stable_kernel_rules.txt says '...not a "this could be a problem"
> type thing'.

So you don't consider lost data because your filesystem is corrupted
as a problem? This is exactly what can happen (and I suffered from it
one time) if you use IOMMU with a buggy driver (typically a network card
driver).

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

