Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZHDNwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZHDNwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 09:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZHDNwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 09:52:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48451 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbZHDNwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 09:52:50 -0400
Subject: Re: stuck process in D state
From: Peter Zijlstra <peterz@infradead.org>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A7837E6.9020301@nets.rwth-aachen.de>
References: <4A7837E6.9020301@nets.rwth-aachen.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Aug 2009 15:43:19 +0200
Message-Id: <1249393399.7924.213.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 15:30 +0200, Arnd Hannemann wrote:
> Hi,
> 
> I have a process in D state on one of our servers. How can I get it killed?
> Seems to be hanging on nfs (but nfs server is up and running).
> Other processes have no problems accessing files on same nfs mount.

You can't, that's what D state means - TASK_UNINTERRUPTIBLE, the only
way it can continue is to make that page its waiting on available.

I seem to remember some people are slowly converting most of those
wait_on_page stuff to interruptible waits, but that's a slow and tricky
business.
