Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbYDUQeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbYDUQeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbYDUQeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:34:08 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:22789 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbYDUQeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:34:07 -0400
Message-Id: <480CDE2B.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 21 Apr 2008 17:34:19 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Roland McGrath" <roland@redhat.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: prevent unconditional writes to DebugCtl MSR
References: <20080418194334.7483627037C@magilla.localdomain>
 <20080421155534.GA1284@elte.hu>
In-Reply-To: <20080421155534.GA1284@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 21.04.08 17:55 >>>
>
>* Roland McGrath <roland@redhat.com> wrote:
>
>> If TIF_DEBUGCTLMSR is ever set on a machine without the support, that 
>> is a bug we should diagnose earlier.  If you want some paranoia, then 
>> keep update_debugctlmsr but make it do:
>> 
>> 	BUG_ON(boot_cpu_data.x86 < 6);
>> 
>> instead.
>
>agreed. Jan, wanna send a fix for this?

Hmm, without knowing the context here I'd say the way it's done in
.25 is quite reasonable; a BUG_ON() here would seem quite rude to
me. I thought it really should be the call sites ensuring this doesn't
get called, and the silent ignoring is just to prevent bringing the
system down. A WARN_ON() (or perhaps even WARN_ON_ONCE()) would
be the most I'd be inclined to add there.

Jan

