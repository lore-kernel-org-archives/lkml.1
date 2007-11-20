Return-Path: <linux-kernel-owner+w=401wt.eu-S1764800AbXKTXg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764800AbXKTXg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763510AbXKTXg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:36:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763384AbXKTXgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:36:25 -0500
Date: Tue, 20 Nov 2007 23:36:12 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Milan Broz <mbroz@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Torsten Kaiser <just.for.lkml@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc2-mm1: kcryptd vs lockdep
Message-ID: <20071120233612.GA9126@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Milan Broz <mbroz@redhat.com>, Ingo Molnar <mingo@elte.hu>,
	Torsten Kaiser <just.for.lkml@googlemail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <64bb37e0711182323v1e2a1341tfc7f20df771b988@mail.gmail.com> <20071119075627.GB28432@elte.hu> <64bb37e0711191134l6dac07a2ie3b4258c43e1f1f0@mail.gmail.com> <4741F97D.6090808@redhat.com> <64bb37e0711192255j3fabd3d9g94544b3d518828a2@mail.gmail.com> <4742F1DE.1090902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4742F1DE.1090902@redhat.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 03:40:30PM +0100, Milan Broz wrote:
> (Note comment in code "It is permissible to free the struct
> work_struct from inside the function that is called from it".)
 
I don't understand yet how lockdep behaves if the work struct gets
reused and the reused one finishes first.

I renamed the kcryptd functions today in an attempt to disentangle this
code a bit more.

  - io->pending reference counting looks correct (though used
inconsistently when comparing READ with WRITE)

  - But what happens if kcryptd_crypt_write_convert_loop() calls
INIT_WORK/queue_work twice?

Alasdair
-- 
agk@redhat.com
