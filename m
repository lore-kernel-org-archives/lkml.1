Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYKFMA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYKFMA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 07:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbYKFMAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 07:00:09 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:35899 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbYKFMAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 07:00:08 -0500
Date: Thu, 6 Nov 2008 11:59:58 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: balbir@linux.vnet.ibm.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 7/6] memcg: add atribute (for change bahavior of
 rmdir)
In-Reply-To: <20081106194153.220157ec.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0811061151130.26541@blonde.site>
References: <20081105171637.1b393333.kamezawa.hiroyu@jp.fujitsu.com>
 <49129493.9070103@linux.vnet.ibm.com> <20081106194153.220157ec.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, KAMEZAWA Hiroyuki wrote:
> On Thu, 06 Nov 2008 12:24:11 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > KAMEZAWA Hiroyuki wrote:
> > > 
> > > 1. change force_empty to do move account rather than forget all
> > 
> > I would like this to be selectable, please. We don't want to break behaviour and
> > not everyone would like to pay the cost of movement.
> 
> How about a patch like this ? I'd like to move this as [2/7], if possible.
> It obviously needs painful rework. If I found it difficult, schedule this as [7/7].
> 
> BTW, cost of movement itself is not far from cost for force_empty.
> 
> If you can't find why "forget" is bad, please consider one more day.

My recollection from a year ago is that force_empty totally violated
the rules established elsewhere, making a nonsense of it all: once a
force_empty had been done, you couldn't really be sure of anything
(perhaps it deserved a Taint flag).

Without studying your proposals at all, I do believe you've a good
chance of creating a sensible and consistent force_empty by moving
account, and abandoning the old "forget all" approach completely.

Hugh
