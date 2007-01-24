Return-Path: <linux-kernel-owner+w=401wt.eu-S933147AbXAXGrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147AbXAXGrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 01:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933128AbXAXGrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 01:47:46 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54673 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933147AbXAXGrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 01:47:45 -0500
Date: Tue, 23 Jan 2007 22:47:42 -0800
From: Andrew Morton <akpm@osdl.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hansjoerg Lipp <hjlipp@web.de>
Subject: Re: [PATCH 2.6.20-rc5] Gigaset ISDN driver error handling fixes
Message-Id: <20070123224742.4b13b2ea.akpm@osdl.org>
In-Reply-To: <20070117174213.A39123427B1@gx110.ts.pxnet.com>
References: <20070117174213.A39123427B1@gx110.ts.pxnet.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jan 2007 18:42:13 +0100 (CET)
Tilman Schmidt <tilman@imap.cc> wrote:

> +	mutex_init(&cs->mutex);
> +	mutex_lock(&cs->mutex);

I have vague memories of making rude comments about this a few months ago.

It is very weird to lock a mutex just after intialising it.  I mean, if any other
thread can lock this mutex then there's a race.  If no other thread can
lock it, then this thread doesn't need to either.
