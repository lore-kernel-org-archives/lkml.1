Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbXCTLS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbXCTLS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 07:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbXCTLS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 07:18:26 -0400
Received: from mx2.go2.pl ([193.17.41.42]:39394 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753641AbXCTLSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 07:18:25 -0400
Date: Tue, 20 Mar 2007 12:22:53 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Neil Brown <neilb@suse.de>,
       Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Subject: Re: dquot.c: possible circular locking Re: [2.6.20] BUG: workqueue leaked lock
Message-ID: <20070320112253.GC1751@ff.dom.local>
References: <20070315191749.GS31960@vanheusden.com> <20070320111701.GB1751@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320111701.GB1751@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 12:17:01PM +0100, Jarek Poplawski wrote:
...
> IMHO lockdep found that two locks are taken in different order:
> 
> -> #1: 1) tty_mutex in con_console() 2) dqptr_sem (somewhere later)
> -> #0: 1) dqptr_sem 2) tty_console in dquot_alloc_space() with print_warning()

Should be:
-> #0: 1) dqptr_sem 2) tty_mutex in dquot_alloc_space() with print_warning()

Jarek P.
