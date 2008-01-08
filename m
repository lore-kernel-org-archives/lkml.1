Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbYAHWqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbYAHWqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYAHWqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:46:08 -0500
Received: from ozlabs.org ([203.10.76.45]:52434 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbYAHWqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:46:07 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18307.64807.204087.375733@cargo.ozlabs.ibm.com>
Date: Wed, 9 Jan 2008 09:45:59 +1100
From: Paul Mackerras <paulus@samba.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       David Miller <davem@davemloft.net>, hskinnemoen@atmel.com,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, tony.luck@intel.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCHv2] kprobes: Introduce is_kprobe_fault()
In-Reply-To: <1199737486.7666.12.camel@brick>
References: <1199737486.7666.12.camel@brick>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison writes:

> Use a central is_kprobe_fault() inline in kprobes.h to remove all
> of the arch-dependant, practically identical implementations in
> avr32, ia64, powerpc, s390, sparc64, and x86.

I don't like the name "is_kprobe_fault" since the function actually
handles the fault - i.e. it does more than just tell the caller
whether this is a kprobes fault.  Something like
"handle_kprobes_fault" or "maybe_handle_kprobes_fault" would be
better IMO.

Paul.
