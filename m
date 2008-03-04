Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbYCDAIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbYCDAIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 19:08:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbYCDAHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 19:07:36 -0500
Received: from relay2.sgi.com ([192.48.171.30]:47563 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751847AbYCDAHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 19:07:35 -0500
Message-Id: <20080304000452.514878384@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 03 Mar 2008 16:04:52 -0800
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: apw@shadowen.org
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org
Subject: [rfc 00/10] [Patch] Page flags: Cleanup, reorg and introduce 5 new flags
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A set of patches that attempts to improve page flag handling. First of all a
method is introduced to generate the page flag functions using macros. Then
the number of page flags used by sparsemem is reduced. All page flag
operations will no longer be macros. All flags will use inline function.

Then we add a way to export enum constants to the preprocessor which allows
us to get rid of __ZONE_COUNT and use the NR_PAGEFLAGS for the dynamic
calculation of actually available page flags for fields.

Optimization of sparsemem vmemmap allows us to avoid the use of page flags
for section ids. The newly available flags are taken for various ongoing
VM projects.

RFC->V1
- Fix various things as suggested by Mel and Kame-san.
- Avoid the #idef CONFIG_PAGEFLAG_EXTENDED. The new page flags
  are always available.

-- 

