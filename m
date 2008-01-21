Return-Path: <linux-kernel-owner+w=401wt.eu-S1759106AbYAUJ5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106AbYAUJ5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 04:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758418AbYAUJ4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 04:56:52 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46095 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758412AbYAUJ4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 04:56:51 -0500
Date: Mon, 21 Jan 2008 09:56:19 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, fischer@norbit.de,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Samuel Ortiz <samuel@sortiz.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: fix isa/pcmcia compile problem
Message-ID: <20080121095619.GC5333@infradead.org>
References: <20080117023514.9df393cf.akpm@linux-foundation.org> <478F7F2B.9000801@linux.vnet.ibm.com> <20080117111104.3baa878e.akpm@linux-foundation.org> <47904927.1040000@linux.vnet.ibm.com> <47905348.1000709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47905348.1000709@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 04:20:40PM +0900, Tejun Heo wrote:
> aha152x.c and fdomain are built twice - once for the isa driver and
> once for the PCMCIA one.  Through #ifdefs, the compiled codes are
> slightly different; thus, global symbols need to be given different
> names depending on which flavor is being built.  This patch adds
> GLOBAL() macro to aha152x.h and fdomain.h which change the symbol
> depending on PCMCIA.
> 
> This bug has always existed but has been masked by the fact the
> drivers/scsi/pcmcia used subdir-(y|m) instead of obj-(y|m) which made
> drivers/scsi/pcmcia/built_in.o not linked into the kernel and thus
> avoided the duplicate symbols during compilation.

The right fix would be to compile it only once and attach it to both
busses.  It would be nice if someone could look into that instead of
hacking around the issue.

