Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZKJQ6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZKJQ6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757251AbZKJQ6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:58:21 -0500
Received: from smtp.outflux.net ([198.145.64.163]:52852 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170AbZKJQ6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:58:20 -0500
Date: Tue, 10 Nov 2009 08:57:38 -0800
From: Kees Cook <kees.cook@canonical.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Jan Beulich <jbeulich@novell.com>, Vegard Nossum <vegardno@ifi.uio.no>,
       Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] [x86] detect and report lack of NX protections
Message-ID: <20091110165738.GH5129@outflux.net>
References: <4ADD1E03.4070200@zytor.com>
 <20091020045513.GU5394@outflux.net>
 <20091109221015.GB5129@outflux.net>
 <4AF8A2C0.5080700@zytor.com>
 <20091110154956.GF5129@outflux.net>
 <4AF9991B.20400@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF9991B.20400@zytor.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 08:47:23AM -0800, H. Peter Anvin wrote:
> On 11/10/2009 07:49 AM, Kees Cook wrote:
> >>
> >> The second clause can only get executed if CONFIG_X86_PAE is unset,
> >> which in turn means _PAGE_NX == 0... so that piece of code is meaningless.
> > 
> > CONFIG_X86_PAE is unset for x86_64, where _PAGE_NX is valid.  (This was
> > the main situation I was trying to address.)  So that chunk runs for
> > non-pae 32bit, and all 64bit:
> > 
> 
> In reality, X86_PAE really should have been defined for 64 bits, since
> 64 bits really is PAE in most aspects.
> 
> Anyway, for the 64-bit case it looks like the proper place for any of
> this is in check_efer() just below, not in this null routine.

64-bit does not set nx_enabled to "1" by default anywhere.  And setting
the default to 1 in check_efer() seemed out of place to me.

-Kees

-- 
Kees Cook
Ubuntu Security Team
