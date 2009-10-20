Return-Path: <linux-kernel-owner+w=401wt.eu-S1752196AbZJTEqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbZJTEqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 00:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbZJTEqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 00:46:13 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47907 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbZJTEqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 00:46:13 -0400
Date: Mon, 19 Oct 2009 21:44:45 -0700
From: Kees Cook <kees.cook@canonical.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Jan Beulich <jbeulich@novell.com>, Vegard Nossum <vegardno@ifi.uio.no>,
       Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [x86] detect and report lack of NX protections
Message-ID: <20091020044445.GT5394@outflux.net>
References: <20091019184234.GN5394@outflux.net>
 <20091020084335.4e8d97e9@infradead.org>
 <20091020020426.GS5394@outflux.net>
 <4ADD1E03.4070200@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADD1E03.4070200@zytor.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 20, 2009 at 11:18:43AM +0900, H. Peter Anvin wrote:
> On 10/20/2009 11:04 AM, Kees Cook wrote:
> >It is possible for x86_64 systems to lack the NX bit (see check_efer())
> >either due to the hardware lacking support or the BIOS having turned
> >off the CPU capability, so NX status should be reported.  Additionally,
> >anyone booting NX-capable CPUs in 32bit mode without PAE will lack NX
> >functionality, so this change provides feedback for that case as well.
> >
> >v2: use "Alert:" instead of "Warning:" to avoid confusiong with WARN_ON()
> >
> 
> They're both wrong.  Both imply that the user needs to take an
> action, which is wrong because the kernel is working as intended.
> If you need to use any kind of alert word, it should be something
> like "Notice:", and it should be KERN_NOTICE or even KERN_INFO.

In the case of a system where the BIOS was shipped with XD not enabled,
the user needs to take an action.  I'm okay with switching to Notice:, but
I don't think KERN_INFO is right.  I would agree, "Alert:" would seem to
be a KERN_ALERT, which is above KERN_CRIT, which this is clearly not.
"Notice" it is.

-Kees

-- 
Kees Cook
Ubuntu Security Team
