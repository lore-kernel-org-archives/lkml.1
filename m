Return-Path: <linux-kernel-owner+w=401wt.eu-S1762086AbYDVVgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762086AbYDVVgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756372AbYDVVgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:36:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756266AbYDVVf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:35:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200804221356.15748.rgetz@blackfin.uclinux.org>
References: <200804221356.15748.rgetz@blackfin.uclinux.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: dhowells@redhat.com, "Greg Ungerer" <gerg@snapgear.com>,
       linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH] mm/nommu.c - return 0 from kobjsize with invalid objects
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Tue, 22 Apr 2008 22:35:10 +0100
Message-ID: <8682.1208900110@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> +	if (!objp || !((page = virt_to_page(objp))) || (unsigned long)objp >= memory_end)

You should probably do the additional test before calling virt_to_page(), just
in case the illegal value you've rejected would otherwise break virt_to_page()
(not very likely, but...).  For valid addresses, you've got to do all the
tests anyway.

David
