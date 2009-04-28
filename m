Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbZD1Ttb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbZD1Ttb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 15:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZD1TtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 15:49:22 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:53008 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752037AbZD1TtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 15:49:21 -0400
Date: Tue, 28 Apr 2009 15:48:24 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 00/15] clean up page aligned data and bss sections
In-Reply-To: <1240938062-3264-1-git-send-email-tabbott@mit.edu>
Message-ID: <alpine.DEB.1.10.0904281527210.1623@vinegar-pot.mit.edu>
References: <1240938062-3264-1-git-send-email-tabbott@mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, Tim Abbott wrote:

> Here's a new version of the page-aligned section cleanup patch
> series.  Changes since last version include:

Sam,

I am close to having prepared another 4 patch series of similar size to 
this one for .data.nosave, .data.cacheline_aligned, .data.init_task, and 
.data.read_mostly.  Along with this page-aligned series and the things 
that have already been merged, I think these are all of the major 
cross-architecture patchsets needed for -ffunction-sections (there will 
remain a good number of section names that only appear on one or two 
architectures).

It seems with this set of patches that we're going to bother all the arch 
maintainers several times if we handle these all completely independently 
(especially since each patch series has patches that depend on patches 
from the previous one).  So, I was thinking perhaps we should proceed as 
follows:

(1) I send a patch series that does the architecture-independent macro 
additions as well as the changes for one architecture (say, x86) to use 
those macros so that they can be reviewed along with the actual usage.

(2) We get those reviewed and merge at least the architecture-independent 
patches

(3) I can send one patch series for each architecture that is just using 
the macros that have already been merged; then the patch series are nicely 
decoupled and each arch maintainer only has to ack a single set of changes 
to their architecture.

Does this plan make sense?

	-Tim Abbott

