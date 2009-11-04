Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbZKDBq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbZKDBq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 20:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbZKDBq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 20:46:56 -0500
Received: from smtp-out.google.com ([216.239.45.13]:24637 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbZKDBqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 20:46:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=uj+gK2wAt5Yryt/n0AUGBzzFD5E69b2EZPK0HgCKqK3v/VHJDtf+L+nxZQyCxY4id
	u2/+pWyGJuD6Xd7sX+3zw==
Date: Tue, 3 Nov 2009 17:46:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       stable@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 2/3] page allocator: Do not allow interrupts to use
 ALLOC_HARDER
In-Reply-To: <alpine.DEB.1.10.0911031208150.21943@V090114053VZO-1>
Message-ID: <alpine.DEB.2.00.0911031739380.1187@chino.kir.corp.google.com>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie> <1256650833-15516-3-git-send-email-mel@csn.ul.ie> <20091027130924.fa903f5a.akpm@linux-foundation.org> <alpine.DEB.2.00.0910271411530.9183@chino.kir.corp.google.com> <20091031184054.GB1475@ucw.cz>
 <alpine.DEB.2.00.0910311248490.13829@chino.kir.corp.google.com> <20091031201158.GB29536@elf.ucw.cz> <4AECCF6A.4020206@redhat.com> <alpine.DEB.1.10.0911021139100.24535@V090114053VZO-1> <alpine.DEB.2.00.0911021249470.22525@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0911031208150.21943@V090114053VZO-1>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Nov 2009, Christoph Lameter wrote:

> If you dont know what "realtime" is then we cannot really implement
> "realtime" behavior in the page allocator.
> 

It's not intended to implement realtime behavior!

This is a convenience given to rt_task() to reduce latency when possible 
by avoiding direct reclaim and allowing background reclaim to bring us 
back over the low watermark.

That's been in the page allocator for over four years and is not intended 
to implement realtime behavior.  These tasks do not rely on memory 
reserves being available.

Is it really hard to believe that tasks with such high priorities are 
given an exemption in the page allocator so that we reclaim in the 
background instead of directly?

I hope we can move this to another thread if people would like to remove 
this exemption completely instead of talking about this trivial fix, which 
I doubt there's any objection to.
