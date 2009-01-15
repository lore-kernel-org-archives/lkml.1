Return-Path: <linux-kernel-owner+w=401wt.eu-S936751AbZAOW7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936751AbZAOW7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936461AbZAOWqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:46:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:33936 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936453AbZAOWqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:46:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rZ+iqw9RdpsoKdZMZrfSxrFatYU2xyZmV3Yd2Y1LXXKofKKTtKYM7y9l4v0z/xbOwW
         pjpBLNjrJ4TkUbPWqAN1fmu09GF0mf2w2yVuPurmr4skLL4dNB3F7zGruOgnU4amny4o
         QukyoN+QRk+XJL58n9NpgcNmRmCMW6u6kpj3k=
Message-ID: <496FBCD1.5050608@gmail.com>
Date: Thu, 15 Jan 2009 23:46:41 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ralf Baechle <ralf@linux-mips.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 27/85] [PATCH 07/44] [CVE-2009-0029] System call wrapper
 infrastructure
References: <20090115215237.906089480@mini.kroah.org> <20090115215950.GB17227@kroah.com>
In-Reply-To: <20090115215950.GB17227@kroah.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2009 10:59 PM, Greg KH wrote:
> +
> +#ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
> +
> +#define SYSCALL_DEFINE(name) static inline long SYSC_##name
> +#define SYSCALL_DEFINEx(x, name, ...)                                        \
> +     asmlinkage long sys_##name(__SC_DECL##x(__VA_ARGS__));          \
> +     static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__));      \

Hmm, we don't support at least gcc 3.4.6 anymore :/. It seems to be the same as in:
http://lkml.org/lkml/2007/12/6/385

It doesn't like inline prototypes.

> +     asmlinkage long SyS_##name(__SC_LONG##x(__VA_ARGS__))           \
> +     {                                                               \
> +             __SC_TEST##x(__VA_ARGS__);                              \
> +             return (long) SYSC_##name(__SC_CAST##x(__VA_ARGS__));   \
> +     }                                                               \
> +     SYSCALL_ALIAS(sys_##name, SyS_##name);                          \
> +     static inline long SYSC_##name(__SC_DECL##x(__VA_ARGS__))

