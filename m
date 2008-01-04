Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYADQzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYADQzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 11:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYADQzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 11:55:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbYADQzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 11:55:35 -0500
Date: Fri, 4 Jan 2008 11:55:24 -0500
From: Rik van Riel <riel@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Eric Whitney <eric.whitney@hp.com>,
       Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: [patch 00/19] VM pageout scalability improvements
Message-ID: <20080104115524.7d906f94@bree.surriel.com>
In-Reply-To: <p73d4sh8s93.fsf@bingen.suse.de>
References: <20080102224144.885671949@redhat.com>
	<1199379128.5295.21.camel@localhost>
	<20080103120000.1768f220@cuia.boston.redhat.com>
	<1199380412.5295.29.camel@localhost>
	<20080103170035.105d22c8@cuia.boston.redhat.com>
	<1199463934.5290.20.camel@localhost>
	<p73d4sh8s93.fsf@bingen.suse.de>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jan 2008 17:34:00 +0100
Andi Kleen <andi@firstfloor.org> wrote:
> Lee Schermerhorn <Lee.Schermerhorn@hp.com> writes:
> 
> > We can easily [he says, glibly] reproduce the hang on the anon_vma lock
> 
> Is that a NUMA platform? On non x86? Perhaps you just need queued spinlocks?

I really think that the anon_vma and i_mmap_lock spinlock hangs are
due to the lack of queued spinlocks.  Not because I have seen your
system hang, but because I've seen one of Larry's test systems here
hang in scary/amusing ways :)

With queued spinlocks the system should just slow down, not hang.

-- 
All rights reversed.
