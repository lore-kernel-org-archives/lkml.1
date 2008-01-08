Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbYAHXCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbYAHXCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 18:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYAHXCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 18:02:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:6294 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbYAHXCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 18:02:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NevWX/4etxH1evCPkTVHj121izLhyuiHr5UDsfKrRTCwT2dgu80viKTji/27FlMS/Z+8CrGFK827i/DGjW4TLotDVr3kJnouT8ZeiX/InnqdnTZnC+t1GmsecyTDCl9dab9GD7LR/0CeiUVJfF0gG8rMDg5m9ELsiFUUp3e31wU=
Subject: Re: [PATCHv2] kprobes: Introduce is_kprobe_fault()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       David Miller <davem@davemloft.net>, hskinnemoen@atmel.com,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, tony.luck@intel.com,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <18307.64807.204087.375733@cargo.ozlabs.ibm.com>
References: <1199737486.7666.12.camel@brick>
	 <18307.64807.204087.375733@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 15:02:04 -0800
Message-Id: <1199833324.6424.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-09 at 09:45 +1100, Paul Mackerras wrote:
> Harvey Harrison writes:
> 
> > Use a central is_kprobe_fault() inline in kprobes.h to remove all
> > of the arch-dependant, practically identical implementations in
> > avr32, ia64, powerpc, s390, sparc64, and x86.
> 
> I don't like the name "is_kprobe_fault" since the function actually
> handles the fault - i.e. it does more than just tell the caller
> whether this is a kprobes fault.  Something like
> "handle_kprobes_fault" or "maybe_handle_kprobes_fault" would be
> better IMO.

Good point, I chose the name based simply on the usage pattern found
in all the callers.  Of your suggestions I like handle_kprobes_fault
better.

How about check_kprobes_fault?  That seems to cover what you were
getting at with maybe_handle_kprobes_fault but is shorter.  That
also fits better with the !CONFIG_KPROBES case.

Harvey



