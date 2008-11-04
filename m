Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430AbYKDTJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430AbYKDTJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYKDTJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:09:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39812 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbYKDTJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:09:25 -0500
Date: Tue, 4 Nov 2008 14:09:09 -0500
From: Christoph Hellwig <hch@infradead.org>
To: T?r?k Edwin <edwintorok@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@ZenIV.linux.org.uk>, srostedt@redhat.com,
       a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
	belongs to. Store thread group leader id, and use it to lookup the
	address in the process's map. We could have looked up the address
	on thread's map, but the thread might not exist by the time we are
	called. The process might not exist either, but if you are reading
	trace_pipe, that is unlikely.
Message-ID: <20081104190909.GA22438@infradead.org>
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <20081102212512.GF28946@ZenIV.linux.org.uk> <490E1B74.6010904@gmail.com> <20081102214042.GG28946@ZenIV.linux.org.uk> <20081103073257.GA13727@elte.hu> <20081104182628.GA6666@infradead.org> <49109657.3000601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49109657.3000601@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 08:37:11PM +0200, T?r?k Edwin wrote:
> Hmm, this is just for visualizing things in /sys/kernel/debug/, can't I
> use something simpler than mangle_path, such as a simple while loop like
> the one below?

Sounds fine to me, although sharing one mangling-scheme for all pathname
outputs certainly does have benefits of less confusion for the user.

