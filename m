Return-Path: <linux-kernel-owner+w=401wt.eu-S1764275AbXJEVHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764275AbXJEVHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 17:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756768AbXJEVHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 17:07:18 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:37650 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764186AbXJEVHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 17:07:16 -0400
X-Originating-Ip: 99.236.101.138
Date: Fri, 5 Oct 2007 17:03:28 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, bbpetkov@yahoo.de,
       linux-kernel@vger.kernel.org, muli@il.ibm.com, satyam@infradead.org,
       amitkale@netxen.com, achim_leubner@adaptec.com
Subject: Re: [PATCH 1/1] unify DMA_..BIT_MASK definitions: v3.1
In-Reply-To: <20071005140050.655b7727.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710051701530.12079@localhost.localdomain>
References: <20070918194647.GA23800@gollum.tnic> <20071005124705.6584e2f9.akpm@linux-foundation.org>
 <4706A20A.5060603@goop.org> <20071005140050.655b7727.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007, Andrew Morton wrote:

> -#define DMA_BIT_MASK(n)	((1ULL<<(n))-1)
> +#define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))

or you could take advantage of the macros in kernel.h and write that
as:

+#define DMA_BIT_MASK(n)      (((n) == 64) ? ULLONG_MAX : ((1ULL<<(n))-1))

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
