Return-Path: <linux-kernel-owner+w=401wt.eu-S1764898AbYA3TTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764898AbYA3TTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbYA3TTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:19:30 -0500
Received: from relay1.sgi.com ([192.48.171.29]:35332 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751822AbYA3TT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:19:29 -0500
Date: Wed, 30 Jan 2008 11:19:28 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jack Steiner <steiner@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, daniel.blueman@quadrics.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 1/6] mmu_notifier: Core code
In-Reply-To: <20080130155306.GA13746@sgi.com>
Message-ID: <Pine.LNX.4.64.0801301116510.27491@schroedinger.engr.sgi.com>
References: <20080130022909.677301714@sgi.com> <20080130022944.236370194@sgi.com>
 <20080130153749.GN7233@v2.random> <20080130155306.GA13746@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008, Jack Steiner wrote:

> Moving to a different lock solves the problem.

Well it gets us back to the issue why we removed the lock. As Robin said 
before: If its global then we can have a huge number of tasks contending 
for the lock on startup of a process with a large number of ranks. The 
reason to go to mmap_sem was that it was placed in the mm_struct and so we 
would just have a couple of contentions per mm_struct.

I'll be looking for some other way to do this.

