Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbXCUSMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbXCUSMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbXCUSMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:12:45 -0400
Received: from mail.screens.ru ([213.234.233.54]:55430 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbXCUSMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:12:44 -0400
Date: Wed, 21 Mar 2007 21:16:35 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Re: [2.6.20] BUG: workqueue leaked lock
Message-ID: <20070321181635.GA570@tv-sign.ru>
References: <17918.11420.155569.991473@notabene.brown> <20070320093753.GA1751@ff.dom.local> <20070320160759.GA107@tv-sign.ru> <20070321080510.GA1939@ff.dom.local> <20070321144620.GC78@tv-sign.ru> <20070321151651.GA4547@ff.dom.local> <20070321152935.GA215@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321152935.GA215@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21, Oleg Nesterov wrote:
>
> On 03/21, Jarek Poplawski wrote:
> >
> > So, if
> > you have another idea for looking after it, let us know.
>
> No, I don't.

Perhaps we can add lockdep_depth() checks to laundromat_main/nfs4_laundromat
to rule out workqueue.c. According to the trace, we return with client_mutex
held, this seems impossible. So we can also print the value of mutex_is_locked()
if lockdep_depth() != 0.

Oleg.

