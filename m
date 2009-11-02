Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbZKBQsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbZKBQsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbZKBQsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:48:51 -0500
Received: from smtp2.ultrahosting.com ([74.213.174.253]:50493 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755637AbZKBQsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:48:50 -0500
Date: Mon, 2 Nov 2009 11:42:36 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Rik van Riel <riel@redhat.com>
cc: Pavel Machek <pavel@ucw.cz>, David Rientjes <rientjes@google.com>,
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
In-Reply-To: <4AECCF6A.4020206@redhat.com>
Message-ID: <alpine.DEB.1.10.0911021139100.24535@V090114053VZO-1>
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie> <1256650833-15516-3-git-send-email-mel@csn.ul.ie> <20091027130924.fa903f5a.akpm@linux-foundation.org> <alpine.DEB.2.00.0910271411530.9183@chino.kir.corp.google.com> <20091031184054.GB1475@ucw.cz>
 <alpine.DEB.2.00.0910311248490.13829@chino.kir.corp.google.com> <20091031201158.GB29536@elf.ucw.cz> <4AECCF6A.4020206@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Oct 2009, Rik van Riel wrote:

> On 10/31/2009 04:11 PM, Pavel Machek wrote:
>
> > But we can't guarantee that enough memory will be ready in the
> > reserves. So if realtime task relies on it, it is broken, and will
> > fail to meet its deadlines from time to time.
>
> Any realtime task that does networking (which may be the
> majority of realtime tasks) relies on the kernel memory
> allocator.

What is realtime in this scenario? There are no guarantees that reclaim
wont have to occur. There are no guarantees anymore and therefore you
cannot really call this realtime.

Is realtime anything more than: "I want to have my patches merged"?

Give some criteria as to what realtime is please. I am all for decreasing
kernel latencies. But some of this work is adding bloat and increasing
overhead.



