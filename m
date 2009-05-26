Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZEZGCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZEZGCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 02:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbZEZGCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 02:02:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43053 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbZEZGCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 02:02:44 -0400
Date: Tue, 26 May 2009 02:02:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] tracing/events: make __string() more general
Message-ID: <20090526060232.GA10669@infradead.org>
References: <4A1B6A2F.2040703@cn.fujitsu.com> <4A1B6A4C.3070407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1B6A4C.3070407@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 12:04:28PM +0800, Li Zefan wrote:
> This changes __string(..., src) to __string(..., len), thus makes it more
> general, and then block TRACE_EVENT() can use it.
> 
> Also introduce __fetch_str(), which is used in TP_assign() and returns
> the address of the string, while __get_str() is used in TP_print().

If you want to make it really generaly dealing with NULL string pointers
would be extremly helpful.  I ran into that limitation (and the length
one fixed here) when converting the XFS tracing over.

