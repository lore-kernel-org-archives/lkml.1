Return-Path: <linux-kernel-owner+w=401wt.eu-S934178AbYA2UCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934178AbYA2UCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 15:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757421AbYA2UCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 15:02:06 -0500
Received: from relay1.sgi.com ([192.48.171.29]:46398 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757368AbYA2UCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 15:02:03 -0500
Date: Tue, 29 Jan 2008 12:02:01 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 6/6] mmu_notifier: Add invalidate_all()
In-Reply-To: <20080129163158.GX3058@sgi.com>
Message-ID: <Pine.LNX.4.64.0801291200550.25300@schroedinger.engr.sgi.com>
References: <20080128202840.974253868@sgi.com> <20080128202924.810792591@sgi.com>
 <20080129163158.GX3058@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Robin Holt wrote:

> What is the status of getting invalidate_all adjusted to indicate a need
> to also call _release?

Release is only called if the mmu_notifier is still registered. If you 
take it out on invalidate_all then there will be no call to release 
(provided you deal with the RCU issues).

