Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbYAWO1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbYAWO1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 09:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYAWO1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 09:27:33 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:56897 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbYAWO1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:27:32 -0500
Date: Wed, 23 Jan 2008 15:27:59 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: akpm@linux-foundation.org, Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, lee.schermerhorn@hp.com,
       Linux MM <linux-mm@kvack.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       hanth Aravamudan <nacc@us.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Fix boot problem in situations where the boot CPU is running on a memoryless node
Message-ID: <20080123142759.GB19161@aepfle.de>
References: <Pine.LNX.4.64.0801181414200.8924@schroedinger.engr.sgi.com> <20080118225713.GA31128@aepfle.de> <20080122195448.GA15567@csn.ul.ie> <20080122214505.GA15674@aepfle.de> <Pine.LNX.4.64.0801221417480.1912@schroedinger.engr.sgi.com> <20080123075821.GA17713@aepfle.de> <20080123105044.GD21455@csn.ul.ie> <20080123121459.GA18631@aepfle.de> <20080123125236.GA18876@aepfle.de> <20080123135513.GA14175@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080123135513.GA14175@csn.ul.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, Mel Gorman wrote:

> This patch in combination with a partial revert of commit
> 04231b3002ac53f8a64a7bd142fde3fa4b6808c6 fixes a regression between 2.6.23
> and 2.6.24-rc8 where a PPC64 machine with all CPUS on a memoryless node fails
> to boot. If approved by the SLAB maintainers, it should be merged for 2.6.24.

This change alone does not help, its not the version I tested.
Will all the changes below go into 2.6.24 as well, in a seperate patch?

-       for_each_node_state(node, N_NORMAL_MEMORY) {
+       for_each_online_node(node) {

