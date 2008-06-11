Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbYFKHWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbYFKHWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 03:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYFKHWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 03:22:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45267 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752848AbYFKHWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 03:22:04 -0400
Date: Wed, 11 Jun 2008 08:05:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Prevent busy looping
Message-ID: <20080611080502.4aa43980@core>
In-Reply-To: <484F7A8D.1040809@gmail.com>
References: <20080416151305.8788.63912.stgit@denkblock.local>
	<20080416163152.GK12774@kernel.dk>
	<87r6d5l9pb.fsf@denkblock.local>
	<20080417071335.GR12774@kernel.dk>
	<87ve2gc1bn.fsf@denkblock.local>
	<484F7A8D.1040809@gmail.com>
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

> Elias's synthetic test case triggered infinite loop because it wasn't
> a proper ->qc_defer().  ->qc_defer() should never defer commands when
> the target is idle.

Target or host ? We *do* defer commands in the case of an idle channel
when dealing with certain simplex controllers that can only issue one
command per host not one per cable (and in fact in the general case we
can defer commands due to activity on the other drive on the cable).

Alan
