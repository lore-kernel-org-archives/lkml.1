Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbXIXHlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbXIXHlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 03:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXIXHlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 03:41:09 -0400
Received: from mx2.go2.pl ([193.17.41.42]:46436 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751756AbXIXHlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 03:41:08 -0400
Date: Mon, 24 Sep 2007 09:43:23 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-ID: <20070924074323.GA2480@ff.dom.local>
References: <20070919140726.GA4603@ff.dom.local> <46F2123A.9070201@bull.net> <20070920072821.GA2065@ff.dom.local> <46F234DB.7030403@bull.net> <46F270DA.5030101@bull.net> <20070921084453.GA1758@ff.dom.local> <46F398C3.3000804@bull.net> <20070921110347.GB1758@ff.dom.local> <20070924065407.GA1776@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924065407.GA1776@ff.dom.local>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 08:54:07AM +0200, Jarek Poplawski wrote:
> After rethinking, this scenario seems to be wrong or very unprobable
> (I'm not sure of all ways "if (--container...)" could be compiled),
> so there should be no such risk - double kfree/vfree is more probable,
> so no danger. More likely is such refcount abuse: ipc_rcu_getref() in
> do_msgsnd() done a bit after ipc_rcu_putref() in freeque() (msq
> pointer acquired by do_msgsend() before freeque() started); then,
> after schedule(), do_msgsnd() can work with kfreed msq_queue structure
> (at least considering classic RCU).

I see this scenario is even more impossible, so you were right,
it's all right at this point.

Jarek P.
