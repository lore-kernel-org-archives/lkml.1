Return-Path: <linux-kernel-owner+w=401wt.eu-S932152AbXB0TfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbXB0TfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbXB0TfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:35:18 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40549 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbXB0TfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:35:15 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 0/5] Lumpy Reclaim V4
Message-ID: <exportbomb.1172604830@kernel>
Date: Tue, 27 Feb 2007 11:33:51 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following this email are five patches which represent the current
state of the lumpy reclaim patches; collectivly lumpy v4.  This
patch kit is designed as a complete drop-in replacement for the
lumpy patches in 2.6.20-mm2.  This stack is split out to show the
incremental changes in this version.  Andrew please replace your
current lumpy stack with this one, you may prefer to fold this kit
into a single patch lumpy-v4.

Comparitive testing between lumpy-v3 and lump-v4 generally shows a
small improvement, coming from the improved matching of pages taken
from the end of the active/inactive list (patch 2 in this series).

I have taken the lumpy-v2 patches and fixes as found in
2.6.20-rc6-mm2 and folded them back into a single patch (collectivly
lumpy v3), updating attribution.  On top of this are are four patches
which represent the updates mainly coming from the detailed review
comments from Andrew Morton:

lumpy-reclaim-v3: folded back base, lumpy-v3,

lumpy-isolate_lru_pages-wants-to-specifically-take-active-or-inactive-pages:
  ensure we take pages of the expected type from the end of
  the active/ inactive lists.  This is both a performance and
  correctness fix,

lumpy-ensure-that-we-compare-PageActive-and-active-safely: ensure
  comparisons between PageActive() and coded booleans are safe
  should PageActive() not return 1/0,

lumpy-update-commentry-on-subtle-comparisons-and-rounding-assumptions:
  update the code commentary to explain the subtle exit conditions, and

lumpy-only-check-for-valid-pages-when-holes-are-present:
  remove expensive check for invalid pages within MAX_ORDER blocks
  where those cannot exist.

Against: 2.6.20-mm2

-apw
