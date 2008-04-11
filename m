Return-Path: <linux-kernel-owner+w=401wt.eu-S1760520AbYDKPHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520AbYDKPHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759461AbYDKPHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:07:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758237AbYDKPHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:07:06 -0400
Date: Fri, 11 Apr 2008 11:06:20 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, drepper@redhat.com, mingo@redhat.com,
       tglx@redhat.com, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] Fix compile breakage caused by asmlinkage_protect
Message-ID: <20080411150620.GF20478@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <alpine.LFD.1.00.0804101447240.3143@woody.linux-foundation.org> <20080410223738.80A8326F992@magilla.localdomain> <20080411114654.GA12270@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0804110744100.3143@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0804110744100.3143@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 07:46:48AM -0700, Linus Torvalds wrote:
> On Fri, 11 Apr 2008, Heiko Carstens wrote:
> > 
> > git commit 54a015104136974262afa4b8ddd943ea70dec8a2
> > "asmlinkage_protect replaces prevent_tail_call" causes this build failure
> > on s390:
> > 
> >   AS      arch/s390/kernel/entry64.o
> > In file included from arch/s390/kernel/entry64.S:14:
> > include/linux/linkage.h:34: error: syntax error in macro parameter list
> > make[1]: *** [arch/s390/kernel/entry64.o] Error 1
> > make: *** [arch/s390/kernel] Error 2
> 
> Ok, that's just _odd_.

Not if (some) kernel assembly files are preprocessed with -traditional-cpp
or -traditional, which supports neither GNU style arg... nor
ISO C99 ... + __VA_ARGS__ vararg macros.

	Jakub
