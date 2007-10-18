Return-Path: <linux-kernel-owner+w=401wt.eu-S1764637AbXJRBte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764637AbXJRBte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 21:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760087AbXJRBt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 21:49:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47992
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759363AbXJRBtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 21:49:25 -0400
Date: Wed, 17 Oct 2007 18:49:24 -0700 (PDT)
Message-Id: <20071017.184924.104034442.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.0.999.0710171834001.26902@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org>
	<20071017.181907.63126798.davem@davemloft.net>
	<alpine.LFD.0.999.0710171834001.26902@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Oct 2007 18:36:34 -0700 (PDT)

> Although I also wonder whether we want one global per-arch 
> ARCH_HAS_SG_CHAIN

It's there because the DMA mapping support code for a platform has to
be converted to handle these chains and audited to make sure the
conversion is right.  Some platforms, such as sparc64, took a lot of
work to get right :-)

Once that macro is set, the block device driver has to support it too,
and there are knobs all the way down to the scsi host driver to
indicate this.

The idea is that all of this mess gets deleted in the end, it was
meant to be a safe transition scheme.

