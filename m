Return-Path: <linux-kernel-owner+w=401wt.eu-S965295AbXH0Vva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965295AbXH0Vva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762963AbXH0Vh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:37:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35304 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765633AbXH0Vhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:37:51 -0400
Date: Mon, 27 Aug 2007 22:37:47 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] clean up exports in fs/{open,read_write}.c
Message-ID: <20070827213747.GA17049@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Eugene Teo <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
	Takashi Iwai <tiwai@suse.de>,
	Arjan van de Ven <arjan@linux.intel.com>
References: <20070824033310.GA5662@kernel.sg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070824033310.GA5662@kernel.sg>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 11:33:10AM +0800, Eugene Teo wrote:
> Takashi-san fixed sound/isa/wavefront/wavefront_synth.c to use
> request_firmware instead of sys_*. Since that is the last driver in the
> kernel that uses sys_{read,close}, this patch kills these exports. sys_open
> is left exported for sparc64 only.

I can't find any spar user of it, so please kill it.  In the case a symbol
is needed only for a particular architecture it's better to do it in the
architecture-specific ksyms file than with an ifdef, btw.

