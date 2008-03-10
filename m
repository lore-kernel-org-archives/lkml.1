Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbYCJLww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbYCJLww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 07:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYCJLwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 07:52:45 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:27551
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbYCJLwo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 07:52:44 -0400
Message-Id: <47D52F3F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Mon, 10 Mar 2008 11:53:19 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <markus.t.metzger@intel.com>, <tglx@linutronix.de>,
       "Roland McGrath" <roland@redhat.com>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix typo(?) in step.c
References: <47CE69B0.76E4.0078.0@novell.com>
 <20080305134150.GA16477@elte.hu>
 <20080306075223.BA28B2700FD@magilla.localdomain>
 <20080306112819.GC17906@elte.hu>
 <20080306120309.E4BE52700FD@magilla.localdomain>
 <20080306131119.GC21359@elte.hu>
In-Reply-To: <20080306131119.GC21359@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 06.03.08 14:11 >>>
>
>* Roland McGrath <roland@redhat.com> wrote:
>
>> I know.  That completely misses the point I just made:
>> 
>>    As I said then, one of my concerns was with the low-level tweaks 
>>    not yet sufficiently baked, independent from my reservations about 
>>    the ptrace feature.  Your #if'ing out of the user ABI additions for 
>>    2.6.25 does nothing to remove the unknown new risks from all the 
>>    tweaks with fingers in the low-level arch stuff.  This is the sort 
>>    of thing I was concerned about.
>> 
>> You didn't revert the parts that ever could have caused problems for 
>> anyone except those using the new ptrace extensions, i.e. changes to 
>> step.c, context switch, whatever else was touched we've lost track of 
>> now.  I keep saying that those are not baked, 100% independent of the 
>> ptrace feature.  You don't seem to be hearing me.
>
>well the issue is that both regset and bts had regressions, so the 
>safest was to do the minimal step of undoing any externally visible 
>changes. Feel free to send a reverter patch for the other lowlevel bts 
>bits as well.

So, is this going to be fully reverted, or is it worth pointing out/fixing
other issues? The thing I'm recognizing right now is that
eee3af4a2c83a97fff107ddc445d9df6fded9ce4 made the writes to
DebugCtlMSR unconditional, which means any attempt to do
debugging on i[345]86 will ultimately cause the kernel to oops. All of
that stuff should really depend on CONFIG_X86_DEBUGCTLMSR...

Jan

