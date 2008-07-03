Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbYGCNjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbYGCNjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbYGCNj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:39:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754503AbYGCNj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:39:26 -0400
Message-ID: <486CD623.8030906@linux-foundation.org>
Date: Thu, 03 Jul 2008 08:37:39 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: Mel Gorman <mel@csn.ul.ie>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
       babydr@baby-dragons.com, lee.schermerhorn@hp.com, a.beregalov@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [problem] raid performance loss with 2.6.26-rc8 on 32-bit x86
 (bisected)
References: <1214877439.7885.40.camel@dwillia2-linux.ch.intel.com>	 <20080701080910.GA10865@csn.ul.ie> <20080701175855.GI32727@shadowen.org>	 <20080701190741.GB16501@csn.ul.ie>	 <1214944175.26855.18.camel@dwillia2-linux.ch.intel.com>	 <20080702051759.GA26338@csn.ul.ie>	 <1215049766.2840.43.camel@dwillia2-linux.ch.intel.com>	 <20080703042750.GB14614@csn.ul.ie>	 <alpine.LFD.1.10.0807022135360.18105@woody.linux-foundation.org>	 <20080703050036.GD14614@csn.ul.ie> <1215064455.15797.4.camel@dwillia2-linux.ch.intel.com>
In-Reply-To: <1215064455.15797.4.camel@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What a convoluted description. Simply put: We clobber the nr_zones field
because we write beyond the bounds of the node_zonelists[] array in
struct pglist_data.
