Return-Path: <linux-kernel-owner+w=401wt.eu-S1765376AbXFRShQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765376AbXFRShQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761886AbXFRShE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:37:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47537 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761584AbXFRShD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:37:03 -0400
Date: Mon, 18 Jun 2007 19:36:51 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: [patch] use __asm__ and __volatile__ in asm-x86_64/msr.h
Message-ID: <20070618183651.GB17112@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mike Frysinger <vapier@gentoo.org>,
	"H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, ak@suse.de
References: <200706180209.36762.vapier@gentoo.org> <467635D8.5060202@zytor.com> <200706181002.21978.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706181002.21978.vapier@gentoo.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 10:02:21AM -0400, Mike Frysinger wrote:
> > This is wrong for two reasons:
> >
> > - MSRs are not accessible in user space.
> > - .section .fixup is not applicable to user space.
> >
> > Anything MSR-related should be protected by __KERNEL__ instead.
> >
> > This NAK doesn't apply to rdtsc* and rdpmc* changes, however, as those
> > instructions are legitimate in userspace.
> 
> then someone needs to audit msr.h for this because currently it lacks 
> __KERNEL__ of any kind yet is exported completely to userspace ... i dont 
> know anything about this instructions so that someone != me
> 
> this is similar to what i heard last time i tried to fixup msr.h for 
> userspace, but the file still hasnt been updated ...

asm-i386/msr.h should not be exported to userspace at all, it contains
nothing but kernel-internal helpers.
