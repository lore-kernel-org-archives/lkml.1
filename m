Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046Ab0AQPqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0AQPqM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 10:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240Ab0AQPqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 10:46:12 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60085 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab0AQPqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 10:46:06 -0500
Date: Sun, 17 Jan 2010 10:46:05 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, hpa@zytor.com, riel@redhat.com,
       cl@linux-foundation.org
Subject: Re: [PATCH v3 05/12] Export __get_user_pages_fast.
Message-ID: <20100117154605.GB27123@infradead.org>
References: <1262700774-1808-1-git-send-email-gleb@redhat.com> <1262700774-1808-6-git-send-email-gleb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262700774-1808-6-git-send-email-gleb@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 04:12:47PM +0200, Gleb Natapov wrote:
> KVM will use it to try and find a page without falling back to slow
> gup. That is why get_user_pages_fast() is not enough.

Btw, it seems like currently is declared unconditionally in linux/mm.h
but only implemented by x86, and you code using it needs ifdefs for
that.  I think you should just introduce a stub that always returns
an error here.

