Return-Path: <linux-kernel-owner+w=401wt.eu-S1760435AbYELJ7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435AbYELJ7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 05:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbYELJ7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 05:59:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57870 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755453AbYELJ7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 05:59:10 -0400
Date: Mon, 12 May 2008 10:48:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 2/3] Blackfin Sports UART Driver: fix bug - the bug
 caused by sport overrun, use timer to flip the tty buffer in order to
 return from rx ISR quickly
Message-ID: <20080512104843.5b6fb486@core>
In-Reply-To: <1210565409-3655-3-git-send-email-cooloney@kernel.org>
References: <1210565409-3655-1-git-send-email-cooloney@kernel.org>
	<1210565409-3655-3-git-send-email-cooloney@kernel.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Can you explain what the timer is for ? If you are trying to push the tty
processing out of the interrupt handler then surely schedule_work would
be sufficient. Also if you don't have tty->low_latency set the tty layer
will already do the actual processing work each timer event not in the
IRQ.
