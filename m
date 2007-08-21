Return-Path: <linux-kernel-owner+w=401wt.eu-S1758190AbXHUIye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190AbXHUIye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 04:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbXHUIy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 04:54:26 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52735 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbXHUIy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 04:54:26 -0400
Date: Tue, 21 Aug 2007 09:54:23 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: Lee.Schermerhorn@hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/6] Embed zone_id information within the zonelist->zones pointer
Message-ID: <20070821085423.GC29794@skynet.ie>
References: <20070817201647.14792.2690.sendpatchset@skynet.skynet.ie> <20070817201748.14792.37660.sendpatchset@skynet.skynet.ie> <Pine.LNX.4.64.0708171400570.9635@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708171400570.9635@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (17/08/07 14:02), Christoph Lameter didst pronounce:
> On Fri, 17 Aug 2007, Mel Gorman wrote:
> 
> > +/*
> > + * SMP will align zones to a large boundary so the zone ID will fit in the
> > + * least significant biuts. Otherwise, ZONES_SHIFT must be 2 or less to
> > + * fit
> 
> ZONES_SHIFT is always 2 or less....
> 

Yeah, I get that but I was trying for future proof at build time.  However,
there is no need to have dead code on the off-chance it is eventually
used. Failing the compile should be enough so now the check looks like;

+/*
+ * SMP will align zones to a large boundary so the zone ID will fit in the
+ * least significant biuts. Otherwise, ZONES_SHIFT must be 2 or less to
+ * fit. Error if it's not
+ */
+#if (defined(CONFIG_SMP) && INTERNODE_CACHE_SHIFT < ZONES_SHIFT) || \
+	ZONES_SHIFT > 2
+#error There is not enough space to embed zone IDs in the zonelist
+#endif
+

> Acked-by: Christoph Lameter <clameter@sgi.com>
> 

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
