Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbYAIH5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbYAIH5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 02:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbYAIH5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 02:57:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54461 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYAIH5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 02:57:41 -0500
Date: Wed, 9 Jan 2008 07:57:32 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       David Miller <davem@davemloft.net>, hskinnemoen@atmel.com,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, tony.luck@intel.com,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCHv3] kprobes: Introduce kprobe_handle_fault()
Message-ID: <20080109075731.GA32560@infradead.org>
References: <1199737486.7666.12.camel@brick> <18307.64807.204087.375733@cargo.ozlabs.ibm.com> <1199833324.6424.12.camel@brick> <1199852360.6424.39.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199852360.6424.39.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 08:19:20PM -0800, Harvey Harrison wrote:
> Use a central kprobe_handle_fault() inline in kprobes.h to remove
> all of the arch-dependant, practically identical implementations in
> avr32, ia64, powerpc, s390, sparc64, and x86.
> 
> avr32 was the only arch without the preempt_disable/enable pair
> in its notify_page_fault implementation.
> 
> This uncovered a possible bug in the s390 version as that purely
> copied the x86 version unconditionally passing 14 as the trapnr
> rather than the error_code parameter.

This is not an equivalnet transformation.  The old code always made
sure to disable preemption and the new one just skips the whole
kprobes handler if preemption is enabled.  Please separate code
consolidation from changing semantics _and_ describe the semantics
changes in detail.

