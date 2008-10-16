Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYJPG5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYJPG5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 02:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYJPG5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 02:57:25 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:46491 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbYJPG5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 02:57:24 -0400
X-IronPort-AV: E=Sophos;i="4.33,422,1220227200"; 
   d="scan'208";a="91707821"
From: Roland Dreier <rdreier@cisco.com>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       markus.t.metzger@gmail.com
Subject: Re: [rfc] x86, bts: improve X86_PTRACE_BTS help text
References: <20081015182902.A30726@sedona.ch.intel.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 15 Oct 2008 23:57:23 -0700
In-Reply-To: <20081015182902.A30726@sedona.ch.intel.com> (Markus Metzger's
	message of "Wed, 15 Oct 2008 18:29:02 +0200")
Message-ID: <ada1vyhc9ik.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Oct 2008 06:57:23.0710 (UTC) FILETIME=[710F61E0:01C92F5C]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for improving the help text; it looks much better.

One comment:

 >  config X86_DS
 > -	bool "Debug Store support"
 > -	default y
 > -	help
 > -	  Add support for Debug Store.
 > -	  This allows the kernel to provide a memory buffer to the hardware
 > -	  to store various profiling and tracing events.
 > +	def_bool X86_PTRACE_BTS
 > +	depends on X86_DEBUGCTLMSR

using def_bool here to get this turned on if X86_PTRACE_BTS is set
doesn't seem scalable to more uses of X86_DS.  I would have thought that
having X86_PTRACE_BTS select X86_DS would make more sense.

Or are other users of X86_DS not planned?  In which case should there be
a separate X86_DS option at all?

 > +	  This adds a ptrace interface to the hardware's branch trace store.
 > +
 > +	  Debuggers may use it to collect an execution trace of the debugged
 > +	  application in order to answer the question 'how did I get here?'.
 > +	  Debuggers may trace user mode as well as kernel mode.
 > +
 > +	  Say Y unless there is no application development on this machine
 > +	  and you want to save a small amount of code size.

This looks much better -- someone like me could read this and make an
informed decision about the config option.

Thanks,
  Roland
