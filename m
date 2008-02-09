Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbYBIPPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbYBIPPN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbYBIPO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:14:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:38524 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYBIPO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:14:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xvTe81mOIflMieUf323rMNk88U4r7KQRRD9HjW1uCr5xvlq0fAWgbsLdv5nOSg7hClbeTlnAX4GeHYJDBEjt0ZhNavjG8x57tW9yDTibgn4bSx9gDycPxbj4ViXlj7OJt8lFN4Y+65GYKAsp+/oKAFKvLP4M8//ctrFENfAUt4o=
Message-ID: <6101e8c40802090714k59a1051rf7598905ca377bb6@mail.gmail.com>
Date: Sat, 9 Feb 2008 16:14:52 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Greg KH" <greg@kroah.com>, stable@kernel.org
Subject: Fwd: [patch 22/27] quicklist: Set tlb->need_flush if pages are remaining in quicklist 0
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Justin M. Forbes" <jmforbes@linuxtx.org>, "Greg KH" <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, dhaval@linux.vnet.ibm.com
In-Reply-To: <6101e8c40802061511k6356cd5cued8d9eb646a27bc9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080202001232.472591439@mini.kroah.org>
	 <20080202002103.GW8368@suse.de>
	 <Pine.LNX.4.64.0802011638330.21566@schroedinger.engr.sgi.com>
	 <1201915720.3781.18.camel@turion.linuxtx.org>
	 <Pine.LNX.4.64.0802011729560.21840@schroedinger.engr.sgi.com>
	 <20080206224520.GA11045@kroah.com>
	 <6101e8c40802061511k6356cd5cued8d9eb646a27bc9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for 2.6.22

---------- Forwarded message ----------
From: Oliver Pinter <oliver.pntr@gmail.com>
Date: Thu, 7 Feb 2008 00:11:58 +0100
Subject: Re: [patch 22/27] quicklist: Set tlb->need_flush if pages are
remaining in quicklist 0
To: Greg KH <greg@kroah.com>
Cc: Christoph Lameter <clameter@sgi.com>, "Justin M. Forbes"
<jmforbes@linuxtx.org>, Greg KH <gregkh@suse.de>,
linux-kernel@vger.kernel.org, stable@kernel.org,
torvalds@linux-foundation.org, Zwane Mwaikambo
<zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap
<rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber
<chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>,
Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert
<cebbert@redhat.com>, Domenico Andreoli <cavokz@gmail.com>,
akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
dhaval@linux.vnet.ibm.com

Greg, the patch in queue-2.6.23 is good for it

but the git id.: 96990a4ae979df9e235d01097d6175759331e88c

-------

>From stable-bounces@linux.kernel.org Tue Jan 15 10:52:21 2008
From: Christoph Lameter <clameter@sgi.com>
Date: Wed, 16 Jan 2008 00:21:19 +0530
Subject: quicklists: Only consider memory that can be used with GFP_KERNEL
To: gregkh@suse.de
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
clameter@sgi.com
Message-ID: <20080115185119.GA6806@linux.vnet.ibm.com>
Content-Disposition: inline

From: Christoph Lameter <clameter@sgi.com>

patch 96990a4ae979df9e235d01097d6175759331e88c in mainline.

Quicklists calculates the size of the quicklists based on the number of
free pages.  This must be the number of free pages that can be allocated
with GFP_KERNEL.  node_page_state() includes the pages in ZONE_HIGHMEM and
ZONE_MOVABLE which may lead the quicklists to become too large causing OOM.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Tested-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/quicklist.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/quicklist.c
+++ b/mm/quicklist.c
@@ -26,9 +26,17 @@ DEFINE_PER_CPU(struct quicklist, quickli
 static unsigned long max_pages(unsigned long min_pages)
 {
 	unsigned long node_free_pages, max;
+	struct zone *zones = NODE_DATA(numa_node_id())->node_zones;
+
+	node_free_pages =
+#ifdef CONFIG_ZONE_DMA
+		zone_page_state(&zones[ZONE_DMA], NR_FREE_PAGES) +
+#endif
+#ifdef CONFIG_ZONE_DMA32
+		zone_page_state(&zones[ZONE_DMA32], NR_FREE_PAGES) +
+#endif
+		zone_page_state(&zones[ZONE_NORMAL], NR_FREE_PAGES);

-	node_free_pages = node_page_state(numa_node_id(),
-			NR_FREE_PAGES);
 	max = node_free_pages / FRACTION_OF_NODE_MEM;
 	return max(max, min_pages);
 }



On 2/6/08, Greg KH <greg@kroah.com> wrote:
> On Fri, Feb 01, 2008 at 05:30:14PM -0800, Christoph Lameter wrote:
> > On Fri, 1 Feb 2008, Justin M. Forbes wrote:
> >
> > >
> > > On Fri, 2008-02-01 at 16:39 -0800, Christoph Lameter wrote:
> > > > NO! Wrong fix. Was dropped from mainline.
> > >
> > > What is the right fix for the OOM issues with 2.6.22? Perhaps
> > > http://marc.info/?l=linux-mm&m=119973653803451&w=2 should be added to
> > > the queue in its place?  The OOM issue in 2.6.22 is real, and should be
> > > addressed.
> >
> > Indeed that is the right fix.
>
> Can someone send it to me, in patch form so that I can apply it?  Along
> with the git id of the same patch in mainline please, I can't seem to
> find it.
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver



-- 
Thanks,
Oliver
