Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZKJQv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZKJQv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757174AbZKJQv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:51:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48744 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbZKJQv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:51:27 -0500
Message-ID: <4AF9991B.20400@zytor.com>
Date: Tue, 10 Nov 2009 08:47:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
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
References: <4ADD1E03.4070200@zytor.com> <20091020045513.GU5394@outflux.net> <20091109221015.GB5129@outflux.net> <4AF8A2C0.5080700@zytor.com> <20091110154956.GF5129@outflux.net>
In-Reply-To: <20091110154956.GF5129@outflux.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 07:49 AM, Kees Cook wrote:
>>
>> The second clause can only get executed if CONFIG_X86_PAE is unset,
>> which in turn means _PAGE_NX == 0... so that piece of code is meaningless.
> 
> CONFIG_X86_PAE is unset for x86_64, where _PAGE_NX is valid.  (This was
> the main situation I was trying to address.)  So that chunk runs for
> non-pae 32bit, and all 64bit:
> 

In reality, X86_PAE really should have been defined for 64 bits, since
64 bits really is PAE in most aspects.

Anyway, for the 64-bit case it looks like the proper place for any of
this is in check_efer() just below, not in this null routine.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

