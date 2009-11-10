Return-Path: <linux-kernel-owner+w=401wt.eu-S1757762AbZKJS52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762AbZKJS52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 13:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757726AbZKJS52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 13:57:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46707 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750AbZKJS51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 13:57:27 -0500
Message-ID: <4AF9B6AD.8020505@zytor.com>
Date: Tue, 10 Nov 2009 10:53:33 -0800
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
Subject: Re: [PATCH v4] [x86] detect and report lack of NX protections
References: <4ADD1E03.4070200@zytor.com> <20091020045513.GU5394@outflux.net> <20091109221015.GB5129@outflux.net> <4AF8A2C0.5080700@zytor.com> <20091110154956.GF5129@outflux.net> <4AF9991B.20400@zytor.com> <20091110165738.GH5129@outflux.net> <4AF99F0C.2050806@zytor.com> <20091110174622.GK5129@outflux.net>
In-Reply-To: <20091110174622.GK5129@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 09:46 AM, Kees Cook wrote:
> 
> The kernel as-is does not set nx_enabled for 64-bit, so this message is
> skipped completely:
> 
>         if (nx_enabled)
>                 printk(KERN_INFO "NX (Execute Disable) protection: active\n");
> 
> The only time this printk is shown is on 32-bit with PAE (with NX).
> There is no "else" currently.
> 

The structure you have is:

	if (nx_enabled)
	else if (cpu_has_pae)

The test for cpu_has_pae is unconditional (you only #ifdef the message)
-- in fact, this should cause a compile-time error on 64 bits:

#undef  cpu_has_pae
#define cpu_has_pae             ___BUG___

	-hpa
