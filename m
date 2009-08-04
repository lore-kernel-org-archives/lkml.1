Return-Path: <linux-kernel-owner+w=401wt.eu-S932904AbZHDPuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbZHDPuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932806AbZHDPug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:50:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41013 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717AbZHDPug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:50:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1249397486.7924.243.camel@twins>
References: <1249397486.7924.243.camel@twins> <s5hvdmos4i8.wl%tiwai@suse.de> <alpine.DEB.2.01.0906211926080.6439@bogon> <6950.1245661098@redhat.com> <24075.1248705430@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: dhowells@redhat.com, Takashi Iwai <tiwai@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>, oleg <oleg@redhat.com>
Subject: Re: Incorrect circular locking dependency?
Date: Tue, 04 Aug 2009 16:50:04 +0100
Message-ID: <18723.1249401004@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

> Creating a new class for your second workqueue might help,

I only have one workqueue.  The problem is there are two waitqueues, but
init_waitqueue_head() always sets q->lock to the same class.

> we'd have to pass a second key through __create_workqueue_key() and pass
> that into init_cpu_workqueue() and apply it to cwq->lock using
> lockdep_set_class() and co.

Actually, wouldn't just making init_cpu_workqueue() apply a class to
cwq->more_work that's common to all workqueues suffice?  Or even, have
init_waitqueue_head() apply an alternate class to q->lock?

David
