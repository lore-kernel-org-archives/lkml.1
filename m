Return-Path: <linux-kernel-owner+w=401wt.eu-S1761124AbZE0HYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761124AbZE0HYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760188AbZE0HY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:24:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49704 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760715AbZE0HY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:24:27 -0400
Date: Wed, 27 May 2009 03:22:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] tracing/events: make __string() more general
Message-ID: <20090527072215.GB24381@infradead.org>
References: <4A1B6A2F.2040703@cn.fujitsu.com> <4A1B6A4C.3070407@cn.fujitsu.com> <alpine.DEB.2.00.0905261655120.26705@gandalf.stny.rr.com> <4A1C9645.7010107@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1C9645.7010107@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 09:24:21AM +0800, Li Zefan wrote:
> Seems Christoph also runs into this problem while doing his XFS tracing.
> (and NULL str ptr that I'm not suffering)


Yeah.  What I'm doing is tracing the XFS directory code.  For some
reason unknown to mankind people decided not to store the 0 termination
on disk because we have the string length in the dirent anyway.  So
beeing able to specify the length is important to me, aswell as dealing
with NULL strings because there are some directory operations that
are internal and don't deal with any entry and thus don't have a name
associated with them.


> > This is why I like the Impact line really be a "rational" line.
> >  "TRACE_EVENT api change" is meaningless to me.
> > 
> 
> So what should this impact be. :(

Another reason for just dropping the impact Lines.  I had hope people
would just stop adding it after the last
flamewar^H^H^H^H^H^H^Hdiscussion.
