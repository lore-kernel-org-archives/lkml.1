Return-Path: <linux-kernel-owner+w=401wt.eu-S1759892AbZEFR5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbZEFR5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 13:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZEFR5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 13:57:04 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:51624 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbZEFR5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 13:57:04 -0400
Date: Wed, 6 May 2009 18:54:22 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Chris Wright <chrisw@redhat.com>
cc: Izik Eidus <ieidus@redhat.com>, Rik van Riel <riel@redhat.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       aarcange@redhat.com, alan@lxorguk.ukuu.org.uk, device@lanana.org,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 3/6] ksm: change the KSM_REMOVE_MEMORY_REGION ioctl.
In-Reply-To: <20090506170917.GE15712@x200.localdomain>
Message-ID: <Pine.LNX.4.64.0905061845540.12391@blonde.anvils>
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com>
 <1241475935-21162-2-git-send-email-ieidus@redhat.com>
 <1241475935-21162-3-git-send-email-ieidus@redhat.com>
 <1241475935-21162-4-git-send-email-ieidus@redhat.com> <4A00DF9B.1080501@redhat.com>
 <4A014C7B.9080702@redhat.com> <Pine.LNX.4.64.0905061110470.3519@blonde.anvils>
 <4A01AC5E.6000906@redhat.com> <20090506161424.GC15712@x200.localdomain>
 <Pine.LNX.4.64.0905061732220.5775@blonde.anvils> <20090506170917.GE15712@x200.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009, Chris Wright wrote:
> * Hugh Dickins (hugh@veritas.com) wrote:
> > 
> > Is the phrase "covert channel" going to come up somehow?
> 
> There's two (still hand wavy) conerns I see there.  First is the security
> implication: timing writes to see cow and guess the shared data for
> another apps VM_LOCKED region,

Mmm, yes, there's fun to be had there; though I don't see it as having
anything to do with VM_LOCKED, beyond that the paranoid have reason to
place their most anxious data in VM_LOCKED areas.

I'm thinking of an app which prepares pages full of scurrilous rumour,
then waits around looking at its /proc/self/smaps to see if anyone else
is writing stories like that!

> second is just plain old complaints of
> those rt latency sensitive apps that somehow have VM_LOCKED|VM_MERGE
> and complain of COW fault time, probably just "don't do that".

Right.  There are sensitive sites which ought not to configure such
merging on; but I don't think we should disallow merging locked.

Hugh
