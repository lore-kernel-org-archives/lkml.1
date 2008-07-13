Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbYGMOeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbYGMOeP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 10:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYGMOd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 10:33:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32848 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753466AbYGMOd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 10:33:59 -0400
Date: Sun, 13 Jul 2008 15:15:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jakub W. Jozwicki" <jozwicki@aster.pl>
Cc: linux-kernel@vger.kernel.org, jgarzik@redhat.com, mingo@elte.hu,
       tglx@timesys.com
Subject: Re: [PATCH 2.6.25.10 1/2] libata: fix locking for kmap_atomic
Message-ID: <20080713151556.79f23215@lxorguk.ukuu.org.uk>
In-Reply-To: <200807131530.03402.jozwicki@aster.pl>
References: <200807130127.36706.jozwicki@aster.pl>
	<20080713112543.2dc9d6f7@lxorguk.ukuu.org.uk>
	<200807131530.03402.jozwicki@aster.pl>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sent patch was for:
> 
> [   16.787021] BUG: sleeping function called from invalid context IRQ-14(5730) 
> at arch/x86/mm/highmem_32.c:8

Fine - but the right fix is still to apply the patches that use a bounce
buffer, otherwise you might paper over the warning but you'll trash rt
performance. It needs fixing anyway especially with Tejun's changes to
the ATAPI logic to use PIO more often

Alan
