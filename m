Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYKDS0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYKDS0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYKDS0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:26:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56521 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYKDS0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:26:46 -0500
Date: Tue, 4 Nov 2008 13:26:28 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, T?r?k Edwin <edwintorok@gmail.com>,
       srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
	belongs to. Store thread group leader id, and use it to lookup the
	address in the process's map. We could have looked up the address
	on thread's map, but the thread might not exist by the time we are
	called. The process might not exist either, but if you are reading
	trace_pipe, that is unlikely.
Message-ID: <20081104182628.GA6666@infradead.org>
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <20081102212512.GF28946@ZenIV.linux.org.uk> <490E1B74.6010904@gmail.com> <20081102214042.GG28946@ZenIV.linux.org.uk> <20081103073257.GA13727@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103073257.GA13727@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 08:32:57AM +0100, Ingo Molnar wrote:
> could you please help out with such a helper? This is really about 
> visualization, not to rely on it.

Is this kindergarten?  Take a look at seq_path - what you want
is the combination of d_path + mangle_path and the combination of two
would be rather trivial.  In fact I'd say you don't even need the helper
but just make mangle_path global (and document it while you're at it)
and then use it.

