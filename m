Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbYJ3UUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbYJ3UUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYJ3UUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:20:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:50576 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbYJ3UUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:20:44 -0400
Date: Thu, 30 Oct 2008 13:21:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Ingo Molnar <mingo@elte.hu>, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, tim@scalemp.com, shai@scalex86.org
Subject: Re: [patch] x86: Fix /dev/mem mmap breakage when PAT is disabled
Message-ID: <20081030132103.2daff1e1@infradead.org>
In-Reply-To: <20081030020203.GA12423@localdomain>
References: <20081030020203.GA12423@localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008 19:02:03 -0700
Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> Fix mmap to /dev/mem when CONFIG_X86_PAT is off and
> CONFIG_STRICT_DEVMEM is off
> 
> mmap to /dev/mem on kernel memory has been failing since the
> introduction of PAT (CONFIG_STRICT_DEVMEM=n case).   Seems like
> the check to avoid cache aliasing with PAT is kicking in even
> when PAT is disabled. The bug seems to have crept in 2.6.26.
> 
> This patch makes sure that mmap to regular kernel memory
> succeeds if CONFIG_STRICT_DEVMEM=n and
> PAT is disabled.  The checks to avoid cache aliasing
> still happens if PAT is enabled.

well... technically the aliases are bad without PAT as well...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
