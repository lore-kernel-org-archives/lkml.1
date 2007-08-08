Return-Path: <linux-kernel-owner+w=401wt.eu-S937027AbXHHX3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937027AbXHHX3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762179AbXHHX27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:28:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53253 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762578AbXHHX26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:28:58 -0400
Date: Wed, 8 Aug 2007 16:28:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: Lee.Schermerhorn@hp.com, pj@sgi.com, ak@suse.de,
       kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] Use one zonelist that is filtered instead of multiple
 zonelists
In-Reply-To: <20070808211032.GB2441@skynet.ie>
Message-ID: <Pine.LNX.4.64.0708081627520.17224@schroedinger.engr.sgi.com>
References: <20070808161504.32320.79576.sendpatchset@skynet.skynet.ie>
 <20070808161545.32320.41940.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0708081041240.12652@schroedinger.engr.sgi.com>
 <20070808211032.GB2441@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Mel Gorman wrote:

> The zone_id is the one I'm really interested in. It looks like the most
> promising optimisation for avoiding zone_idx in the hotpath.

Certainly the highest priority. However, if the nodeid could be coded in 
then we may be able to also avoid the GFP_THISNODE zonelists and improve 
the speed of matching a zonelist to a node mask.

