Return-Path: <linux-kernel-owner+w=401wt.eu-S1764895AbXKQSu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764895AbXKQSu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:50:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758845AbXKQSuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 13:50:14 -0500
Received: from [198.99.130.12] ([198.99.130.12]:35764 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757545AbXKQSuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 13:50:12 -0500
Date: Sat, 17 Nov 2007 13:49:54 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH 7/8] UML - add virt_to_pte
Message-ID: <20071117184954.GB8206@c2.user-mode-linux.org>
References: <20071116214227.GA13877@c2.user-mode-linux.org> <473EC75F.5020208@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473EC75F.5020208@tiscali.nl>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 11:50:07AM +0100, Roel Kluin wrote:
> > +	if (!pte_present(*pte))
> > +		pte = NULL;
> 
> shouldn't you check again for (pte == NULL)?

No, because if the page isn't mapped, handle_page_fault would have
returned non-zero, and we would have already returned.

This is leaving aside issues of whether the page could have been
unmapped by another CPU (which isn't an issue right now, and for which
I have a patch to fix anyway).

				Jeff

-- 
Work email - jdike at linux dot intel dot com
