Return-Path: <linux-kernel-owner+w=401wt.eu-S1763244AbZAPIpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763244AbZAPIpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbZAPIo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:44:56 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:19457 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbZAPIoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:44:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=O08IveMNYnVXxvft4tkEdAmsRUs+7/L0uHyJQh45W96y9gmtC+vOnoFMhqKNDQ0FEn
         zAYeaG2KiAdaYNXaFSQoQEIri/rn4of4Ean6K7cIZzfXhCN9O69oIjBuW4gWUDsyBTs9
         1Ou6GlhIc/fS+Ul4XwlsqN657yod1DMilkdLw=
Message-ID: <49704903.8050301@gmail.com>
Date: Fri, 16 Jan 2009 09:44:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, alan@lxorguk.ukuu.org.uk,
       Eugene Teo <eteo@redhat.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, stable@kernel.org,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Chuck Wolber <chuckw@quantumlinux.com>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Justin Forbes <jmforbes@linuxtx.org>, Jake Edge <jake@lwn.net>,
       Dave Jones <davej@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Willy Tarreau <w@1wt.eu>,
       Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [stable] [patch 27/85] [PATCH 07/44] [CVE-2009-0029] System call
 wrapper infrastructure
References: <20090115215237.906089480@mini.kroah.org> <20090115215950.GB17227@kroah.com> <496FBCD1.5050608@gmail.com> <20090115234237.GA20132@kroah.com> <20090116083747.GB5157@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090116083747.GB5157@osiris.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2009 09:37 AM, Heiko Carstens wrote:
> On Thu, Jan 15, 2009 at 03:42:37PM -0800, Greg KH wrote:
>> On Thu, Jan 15, 2009 at 11:46:41PM +0100, Jiri Slaby wrote:
>>> On 01/15/2009 10:59 PM, Greg KH wrote:
>>>> +
>>>> +#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
>>>> +
>>>> +#define SYSCALL_DEFINE(name) static inline long SYSC_##name
>>>> +#define SYSCALL_DEFINEx(x, name, ...)                                        \
>>>> +     asmlinkage long sys_##name(__SC_DECL##x(__VA_ARGS__));          \
>>>> +     static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__));      \
>>> Hmm, we don't support at least gcc 3.4.6 anymore :/. It seems to be the same as in:
>>> http://lkml.org/lkml/2007/12/6/385
>>>
>>> It doesn't like inline prototypes.
> 
> Compiles fine for me on s390 with gcc 3.4.6 on git head.
> Could you send the .config please?

Hi,

it's not matter of .config. It's matter of compiler. I can't reproduce it on my
own, I just know, that Dave had problems with inline prototypes and using of the
function they declare before the body itself was available with some gcc 3.4.6.

Dave, don't you remember where did you get the compiler from and what was the
platform?
