Return-Path: <linux-kernel-owner+w=401wt.eu-S1761396AbXHVJmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761396AbXHVJmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757749AbXHVJmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 05:42:23 -0400
Received: from mx2.go2.pl ([193.17.41.42]:41194 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756750AbXHVJmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 05:42:21 -0400
Date: Wed, 22 Aug 2007 11:43:25 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] do_sigaction: don't worry about signal_pending()
Message-ID: <20070822094325.GF1684@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070820160157.GA1279@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-08-2007 18:01, Oleg Nesterov wrote:
> do_sigaction() returns -ERESTARTNOINTR if signal_pending(). The comment says:
> 
> 	* If there might be a fatal signal pending on multiple
> 	* threads, make sure we take it before changing the action.
> 	
> I think this is not needed. We should only worry about SIGNAL_GROUP_EXIT case,
> bit it implies a pending SIGKILL which can't be cleared by do_sigaction.

Isn't it for optimization e.g., to skip this 'do while' loop below for
such multiple threads, which would get SIGKILL or SIGSTOP anyway?

Regards,
Jarek P.
