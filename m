Return-Path: <linux-kernel-owner+w=401wt.eu-S1763213AbXJRBO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763213AbXJRBO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 21:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759303AbXJRBOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 21:14:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52871 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422AbXJRBOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 21:14:49 -0400
Message-ID: <4716B37B.3050102@pobox.com>
Date: Wed, 17 Oct 2007 21:14:35 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <alpine.LFD.0.999.0710171321400.26902@woody.linux-foundation.org> <20071017203140.GF15552@kernel.dk> <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org> <20071018080048O.fujita.tomonori@lab.ntt.co.jp> <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On a related hardware note:

FWIW, most ATA controllers have scatter/gather tables that terminate 
themselves by a bit in the final s/g entry.  The 90% case needs to know 
the last scatterlist entry, at the end of the s/g walk.

So however this all gets worked out, please make sure not to unduly 
punish libata controllers with an expensive sg_last() inside a loop, or 
something like that.  :)

	Jeff




