Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbYHICgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbYHICgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 22:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbYHICgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 22:36:25 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:59127 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbYHICgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 22:36:25 -0400
Message-ID: <489D025E.3030901@cs.columbia.edu>
Date: Fri, 08 Aug 2008 22:35:10 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC][PATCH 2/4] checkpoint/restart: x86 support
References: <20080807224033.FFB3A2C1@kernel>	 <200808081409.30591.arnd@arndb.de> <489CAC70.7090809@cs.columbia.edu>	 <200808090029.28286.arnd@arndb.de> <489CD0F9.9060603@cs.columbia.edu>	 <1218242286.19082.62.camel@nimitz>  <489CF0CE.1000603@cs.columbia.edu> <1218248458.19082.68.camel@nimitz>
In-Reply-To: <1218248458.19082.68.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dave Hansen wrote:
> On Fri, 2008-08-08 at 21:20 -0400, Oren Laadan wrote:
>> hehehe .. both; I meant that while it doesn't change per architecture, it
>> varies between architectures. So "struct pt_regs" compiled for x86-32 is
>> different than that compiled for x86-64. Therefore we can't just dump the
>> structure as is and expect that 64 bit would be able to parse the 32 bit.
>> In other words, we need an intermediate representation.
> 
> Surely we already handle this, though.  Don't we allow a 32-bit app
> running on a 64-bit kernel to PTRACE_GETREGS and get the 32-bit version?
> A 64-bit app will get the 64-bit version making the same syscall.  It's
> all handled in the syscall compatibility code.

Sure, that's a compatibility layer around ptrace() in the 64-bit kernel.

Recall that Arnd suggested "keeping the format identical between the
variations of each architecture", and I fully agree. If we want to keep
the format identical, we can't simply define:
	struct cr_hdr_cpu {
		struct pt_regs regs;
		...
	};
because that will compile differently on x86-32 and x86-64. So either we
add r8..r15 to the structure as it appears in the patch now (and keep the
format identical), or allow the format to vary, and explicitly test for
this case and add a compatibility layer. Personally I prefer the former.

Oren.

