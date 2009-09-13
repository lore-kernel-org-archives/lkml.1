Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZIMUQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZIMUQJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 16:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbZIMUQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 16:16:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36848 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbZIMUQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 16:16:07 -0400
Message-ID: <4AAD51C5.3050803@kernel.org>
Date: Sun, 13 Sep 2009 13:10:45 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Roland McGrath <roland@redhat.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH 1/2] UNREACHABLE() macro
References: <20090910015923.8FB628AE5F@magilla.sf.frob.com> <20090910020031.87DC68BF6E@magilla.sf.frob.com> <20090911134528.cd1782d9.akpm@linux-foundation.org> <20090911215525.12B366A98F@magilla.sf.frob.com> <20090912054906.22b05848@infradead.org> <4AAB26FE.7010309@kernel.org> <20090911225228.e67460f5.akpm@linux-foundation.org> <20090912063840.GR14664@tyan-ft48-01.lab.bos.redhat.com>
In-Reply-To: <20090912063840.GR14664@tyan-ft48-01.lab.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2009 11:38 PM, Jakub Jelinek wrote:
>>>
>>> That works for flags, but not for the presence of builtin functions.
>>> You can't even just try compiling something, since it will turn into an
>>> ordinary function if not present... not obvious until link.
>>
>> Use -Wall -Werror and if the compiler doesn't know about
>> __builtin_unreachable() it will error out.
> 
> Yeah, e.g. checking exit status of:
> echo '__attribute__((noreturn)) void foo (void) { asm volatile ("" : : : "memory"); __builtin_unreachable (); }' | gcc -S -O2 -W -Wall -Werror -xc - -o /dev/null > /dev/null 2>/dev/null
> works.
> 

OK, that makes sense... although perhaps it would be cleaner to use
something that could work for other builtins.

One advantage of using "nm" would be that it could answer the general
question "does this version of gcc support __builtin_X() without
resorting to libgcc", which matters quite a bit for functions like
__builtin_ctzl() and so on.

	-hpa
