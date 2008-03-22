Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbYCVSnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbYCVSnV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 14:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbYCVSnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 14:43:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55255 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbYCVSnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 14:43:12 -0400
Date: Sat, 22 Mar 2008 11:40:43 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [00/14] Virtual Compound Page Support V3
Message-ID: <20080322114043.17833ab4@laptopd505.fenrus.org>
In-Reply-To: <20080321061703.921169367@sgi.com>
References: <20080321061703.921169367@sgi.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008 23:17:03 -0700
Christoph Lameter <clameter@sgi.com> wrote:

> Allocations of larger pages are not reliable in Linux. If larger
> pages have to be allocated then one faces various choices of allowing
> graceful fallback or using vmalloc with a performance penalty due
> to the use of a page table. Virtual Compound pages are
> a simple solution out of this dilemma.


can you document the drawback of large, frequent vmalloc() allocations at least?
On 32 bit x86, the effective vmalloc space is 64Mb or so (after various PCI bars are ioremaped),
so if this type of allocation is used for a "scales with nr of ABC" where "ABC" is workload dependent,
there's a rather abrupt upper limit to this.
Not saying that that is a flaw of your patch, just pointing out that we should discourage usage of 
the "scales with nr of ABC" (for example "one for each thread") kind of things.
