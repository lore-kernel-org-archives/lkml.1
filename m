Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbYEORyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbYEORyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbYEORyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:54:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58034 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762297AbYEORyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:54:40 -0400
Date: Thu, 15 May 2008 10:54:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       len.brown@intel.com, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend/Resume bug in PCI layer wrt quirks
Message-ID: <20080515105426.24ee37d9@infradead.org>
In-Reply-To: <200805150907.06930.jbarnes@virtuousgeek.org>
References: <20080515070546.6ea9c681@infradead.org>
	<200805150907.06930.jbarnes@virtuousgeek.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 09:07:06 -0700
> > internally. ioremap()/iounmap() does a global tlb flush of course,
> > which includes doing an IPI to other cpus. However, during early
> > resume, interrupts are disabled, and it's not allowed to do a
> > IPI/global tlbflush with interrupts off...
> 
> Yeah I just got a similar report for quirk_vialatency().  But why are
> we only seeing these issues now?  Is our interrupt disabled check
> catching more stuff these days?

we're now more systematically collecting WARN_ON()'s.....
