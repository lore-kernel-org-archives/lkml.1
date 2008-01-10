Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbYAJAZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbYAJAZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757310AbYAJAZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:25:22 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:52916 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256AbYAJAZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:25:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=G/SIq4vUdHqB7qlRl14ZA0gaFoHqIuJ+s3wpfD+2UsS6nlDCuSTAD5BUlIp4CPoR6GWCgAv3p44W6QPFxoeVWJQiZ0M96Y8fJfbSieX3RR5KhaWrcLfQOgYiol2dgrwBqAR9rGkbAPY1gW2d2i0rLqRWS2AGqZKf7S+B+Uw9kSs=
Subject: Re: [PATCHv4] kprobes: Introduce kprobe_handle_fault()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       David Miller <davem@davemloft.net>, hskinnemoen@atmel.com,
       schwidefsky@de.ibm.com, tony.luck@intel.com,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       David Wilder <dwilder@us.ibm.com>, jkenisto@us.ibm.com
In-Reply-To: <20080109231620.GA9002@osiris.ibm.com>
References: <1199737486.7666.12.camel@brick>
	 <18307.64807.204087.375733@cargo.ozlabs.ibm.com>
	 <1199833324.6424.12.camel@brick> <1199852360.6424.39.camel@brick>
	 <20080109061408.GA9486@osiris.ibm.com> <1199859742.6424.44.camel@brick>
	 <1199916062.6424.60.camel@brick>  <20080109231620.GA9002@osiris.ibm.com>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 16:25:17 -0800
Message-Id: <1199924717.6424.76.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-10 at 00:16 +0100, Heiko Carstens wrote:
> >  arch/avr32/mm/fault.c   |   21 +--------------------
> >  arch/ia64/mm/fault.c    |   24 +-----------------------
> >  arch/powerpc/mm/fault.c |   25 +------------------------
> >  arch/s390/mm/fault.c    |   25 +------------------------
> >  arch/sparc64/mm/fault.c |   23 +----------------------
> >  arch/x86/mm/fault_64.c  |   23 ++---------------------
> >  include/linux/kprobes.h |   17 +++++++++++++++++
> >  7 files changed, 24 insertions(+), 134 deletions(-)
> 
> Somehow I think you missed arch/x86/mm/fault_32.c :)
> 

X86_32 _needs_ !user_mode_vm() as opposed to all of the others needing
!user_mode(), I was planning to deal with this in the unification of
fault_32|64.c at a later date.  So for now X86_32 will not use this.

> > This uncovered a possible bug in the s390 version as that purely
> > copied the x86 version unconditionally passing 14 as the trapnr
> > rather than the error_code parameter.

> 
> Uhm.. yes. 14 is HFP-Significance exception. That doesn't make too much
> sense. Passing error_code here would be the right thing to do.
> Also I just checked with David Wilder: system tap itself doesn't have any
> fault handlers. So it should be safe to change this.

OK, I will send a two patch series as per Christoph's request and will
include the s390 error_code fix instead of 14.

Cheers,

Harvey

