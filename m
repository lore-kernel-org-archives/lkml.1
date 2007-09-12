Return-Path: <linux-kernel-owner+w=401wt.eu-S970596AbXILRH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970596AbXILRH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970531AbXILRGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:06:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45511 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968378AbXILRGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:06:51 -0400
Date: Wed, 12 Sep 2007 10:06:49 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>, Lee.Schermerhorn@hp.com,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 4/6] Embed zone_id information within the zonelist->zones
 pointer
In-Reply-To: <20070912165138.5deb4db4.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0709121005090.1144@schroedinger.engr.sgi.com>
References: <20070911213006.23507.19569.sendpatchset@skynet.skynet.ie>
 <20070911213127.23507.34058.sendpatchset@skynet.skynet.ie>
 <20070912165138.5deb4db4.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007, KAMEZAWA Hiroyuki wrote:

> If we really want to avoid unnecessary access to "zone" while walking zonelist,
> above may do something good.  Cons is this makes sizeof zonlist bigger.

The trouble is that the size of the zonelist would double with this 
approach. We have long zonelists and doubling the size could double 
the cachelines needed to be touched in order to scan the zonelists.
