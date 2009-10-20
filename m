Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbZJTCZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbZJTCZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 22:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932437AbZJTCZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 22:25:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59140 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355AbZJTCZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 22:25:45 -0400
Message-ID: <4ADD1E03.4070200@zytor.com>
Date: Tue, 20 Oct 2009 11:18:43 +0900
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Jan Beulich <jbeulich@novell.com>, Vegard Nossum <vegardno@ifi.uio.no>,
       Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] [x86] detect and report lack of NX protections
References: <20091019184234.GN5394@outflux.net> <20091020084335.4e8d97e9@infradead.org> <20091020020426.GS5394@outflux.net>
In-Reply-To: <20091020020426.GS5394@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2009 11:04 AM, Kees Cook wrote:
> It is possible for x86_64 systems to lack the NX bit (see check_efer())
> either due to the hardware lacking support or the BIOS having turned
> off the CPU capability, so NX status should be reported.  Additionally,
> anyone booting NX-capable CPUs in 32bit mode without PAE will lack NX
> functionality, so this change provides feedback for that case as well.
>
> v2: use "Alert:" instead of "Warning:" to avoid confusiong with WARN_ON()
>

They're both wrong.  Both imply that the user needs to take an action, 
which is wrong because the kernel is working as intended.  If you need 
to use any kind of alert word, it should be something like "Notice:", 
and it should be KERN_NOTICE or even KERN_INFO.

	-hpa
