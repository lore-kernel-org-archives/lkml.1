Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbZFMVyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbZFMVyN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 17:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZFMVx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 17:53:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62041 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbZFMVx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 17:53:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/2] lib: Provide generic atomic64_t implementation
Date: Sat, 13 Jun 2009 23:53:38 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: benh@kernel.crashing.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
References: <18995.20685.227683.561827@cargo.ozlabs.ibm.com>
In-Reply-To: <18995.20685.227683.561827@cargo.ozlabs.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906132353.39269.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+clX7OMpVF0ILFbPoHd0qikv/Xj7W2Tekinpi
 BYz653NNNcQAdTaXgmMApsWQL3T3rqmJEGmyL1qmk9tGZ+OjBc
 wZgDtuHC1bdTF2cS46FGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 June 2009, Paul Mackerras wrote:
> +extern long long atomic64_read(const atomic64_t *v);
> +extern void     atomic64_set(atomic64_t *v, long long i);
> +extern void     atomic64_add(long long a, atomic64_t *v);
> +extern long long atomic64_add_return(long long a, atomic64_t *v);
> +extern void     atomic64_sub(long long a, atomic64_t *v);
> +extern long long atomic64_sub_return(long long a, atomic64_t *v);
> +extern long long atomic64_dec_if_positive(atomic64_t *v);
> +extern long long atomic64_cmpxchg(atomic64_t *v, long long o, long long n);
> +extern long long atomic64_xchg(atomic64_t *v, long long new);
> +extern int      atomic64_add_unless(atomic64_t *v, long long a, long long u);
> +
> +#define atomic64_add_negative(a, v)    (atomic64_add_return((a), (v)) < 0)
> +#define atomic64_inc(v)                        atomic64_add(1LL, (v))
> +#define atomic64_inc_return(v)         atomic64_add_return(1LL, (v))
> +#define atomic64_inc_and_test(v)       (atomic64_inc_return(v) == 0)
> +#define atomic64_sub_and_test(a, v)    (atomic64_sub_return((a), (v)) == 0)
> +#define atomic64_dec(v)                        atomic64_sub(1LL, (v))
> +#define atomic64_dec_return(v)         atomic64_sub_return(1LL, (v))
> +#define atomic64_dec_and_test(v)       (atomic64_dec_return((v)) == 0)
> +#define atomic64_inc_not_zero(v)       atomic64_add_unless((v), 1LL, 0LL)
> +

How about also doing these:?

#define atomic64_sub(a, v)		atomic64_add(-a, v)
#define atomic64_sub_return(a, v)	atomic64_add_return(-a, v)
#define atomic64_add(a, v)		(void)atomic64_add_return(a, v)

The cost to the caller (one or two instruction per call site)
seems to be about the same as for the other wrapper macros.

	Arnd <><
