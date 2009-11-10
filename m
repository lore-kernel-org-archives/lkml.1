Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbZKJU3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbZKJU3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbZKJU3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:29:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46824 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982AbZKJU3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:29:32 -0500
Message-ID: <4AF9CC43.50103@zytor.com>
Date: Tue, 10 Nov 2009 12:25:39 -0800
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
References: <4ADD1E03.4070200@zytor.com> <20091020045513.GU5394@outflux.net> <20091109221015.GB5129@outflux.net> <4AF8A2C0.5080700@zytor.com> <20091110154956.GF5129@outflux.net> <4AF9991B.20400@zytor.com> <20091110165738.GH5129@outflux.net> <4AF99F0C.2050806@zytor.com> <20091110174622.GK5129@outflux.net> <4AF9B6AD.8020505@zytor.com> <20091110194304.GW5129@outflux.net>
In-Reply-To: <20091110194304.GW5129@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The more I stare at the underlying code, the more I'm convinced that the
fundamental problem is that the underlying code is insane, with multiple
levels of detection for what amounts to cpu_has_nx, each effectively
checking what the previous code has done.

check_efer(), for example, screws with EFER, but EFER is simply set in
head_64.S from CPUID (unless Xen does something insane -- but if so, Xen
should clear X86_FEATURE_NX instead.)

The 32-bit startup code also sets NX, but yet on 32 bits we wiggle EFER
as if it had never been.  This code is screaming for cleanup and
unification.

	-hpa

