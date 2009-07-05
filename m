Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbZGETCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbZGETCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 15:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbZGETCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 15:02:10 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62987 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZGETCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 15:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cacAzNTsOWhp7MtY/hESEPuNZfp/r6Lv5AuTeJrbiT8oFn+GZ+GDEh5YULibzDYJlZ
         zKl4yZGlD+dpf8mIUOx9xpcaeFB0RVaGZnmq5XmmvHnnJ0lbka4SrlQH/4T2WVLymYxN
         CoHKBM/Nmoau0Rh3q+QOc4rGlQ/u9BlWrWXMg=
Date: Sun, 5 Jul 2009 23:02:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,apic -- reduce disable_apic usage
Message-ID: <20090705190211.GK4791@lenovo>
References: <20090705162044.GC4791@lenovo> <alpine.LFD.2.00.0907051737100.13862@eddie.linux-mips.org> <4A50E323.6060109@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A50E323.6060109@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Sun, Jul 05, 2009 at 10:30:11AM -0700]
| Maciej W. Rozycki wrote:
| > 
| >  How do you set cpu_has_apic for systems with discrete local APICs?  The 
| > CPUID flag is not set in this case.
| > 
| 
| Well, should it be?  We do set flags when they're appropriate to us, and
| if the semantics are such as that is inappropriate we can set a custom bit.
| 
| 	-hpa
| 

Peter, Maciej but how kernel behaved on older cpu long time ago?

I mean -- should user pass "lapic" cmdline option too be
able to use apic functionality? (i'm asking since I just
don't know how it had been working before). Current
code (if only I'm not _missing_ something) relies on cpu_has_apic
bit. And even if MP table has been parsed and APIC base found,
cpu_has_apic could be not set so detect_init_APIC will fail
if no "lapic" option passed (in case of old cpu without this cpuid
bit produced) as we eventually stay with pic mode.

	-- Cyrill
