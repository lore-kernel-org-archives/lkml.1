Return-Path: <linux-kernel-owner+w=401wt.eu-S1757098AbXHUIwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbXHUIwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 04:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbXHUIvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 04:51:50 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52676 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbXHUIvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 04:51:49 -0400
Date: Tue, 21 Aug 2007 09:51:47 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: Lee.Schermerhorn@hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 2/6] Use one zonelist that is filtered instead of multiple zonelists
Message-ID: <20070821085147.GB29794@skynet.ie>
References: <20070817201647.14792.2690.sendpatchset@skynet.skynet.ie> <20070817201728.14792.42873.sendpatchset@skynet.skynet.ie> <Pine.LNX.4.64.0708171355580.9635@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708171355580.9635@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (17/08/07 13:59), Christoph Lameter didst pronounce:
> On Fri, 17 Aug 2007, Mel Gorman wrote:
> 
> > +/* Returns the first zone at or below highest_zoneidx in a zonelist */
> > +static inline struct zone **first_zones_zonelist(struct zonelist *zonelist,
> > +					enum zone_type highest_zoneidx)
> > +{
> > +	struct zone **z;
> > +	for (z = zonelist->zones; zone_idx(*z) > highest_zoneidx; z++);
> > +	return z;
> > +}
> 
> The formatting above is a bit confusing. Add requires empty lines and put 
> the ; on a separate line.
> 
> 
> > +/* Returns the next zone at or below highest_zoneidx in a zonelist */
> > +static inline struct zone **next_zones_zonelist(struct zone **z,
> > +					enum zone_type highest_zoneidx)
> > +{
> > +	for (++z; zone_idx(*z) > highest_zoneidx; z++);
> 
> Looks weird too.
> 
> ++z on an earlier line and then
> 
> 	for ( ; zone_idx(*z) ...)
> 
> ?
> 

Ok, the relevant section now looks like

+/* Returns the first zone at or below highest_zoneidx in a zonelist */
+static inline struct zone **first_zones_zonelist(struct zonelist *zonelist,
+					enum zone_type highest_zoneidx)
+{
+	struct zone **z;
+
+	for (z = zonelist->zones;
+			zone_idx(*z) > highest_zoneidx;
+			z++)
+		;
+
+	return z;
+}
+
+/* Returns the next zone at or below highest_zoneidx in a zonelist */
+static inline struct zone **next_zones_zonelist(struct zone **z,
+					enum zone_type highest_zoneidx)
+{
+	/* Advance to the next zone in the zonelist */
+	z++;
+
+	/* Find the next suitable zone to use for the allocation */
+	for (; zone_idx(*z) > highest_zoneidx; z++)
+		;
+
+	return z;
+}

Is that better?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
