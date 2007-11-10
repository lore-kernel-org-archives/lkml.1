Return-Path: <linux-kernel-owner+w=401wt.eu-S932108AbXKJB0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbXKJB0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 20:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbXKJB0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 20:26:30 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbXKJB03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 20:26:29 -0500
Message-ID: <473508E3.1050903@redhat.com>
Date: Fri, 09 Nov 2007 23:26:59 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, ak@suse.de,
       virtualization@lists.linux-foundation.org, chrisw@sous-sol.org,
       tglx@linutronix.de, anthony@codemonkey.ws, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu
Subject: Re: [PATCH 1/24] mm/sparse-vmemmap.c: make sure init_mm is included
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <4734E6A0.6070508@goop.org>
In-Reply-To: <4734E6A0.6070508@goop.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jeremy Fitzhardinge escreveu:
> Glauber de Oliveira Costa wrote:
>> mm/sparse-vmemmap.c uses init_mm in some places.  However, it is not
>> present in any of the headers currently included in the file.
>>
>> init_mm is defined as extern in sched.h, so we add it to the headers list
>>
>> Up to now, this problem was masked by the fact that functions like
>> set_pte_at() and pmd_populate_kernel() are usually macros that expand to
>> simpler variants that does not use the first parameter at all.
>>
>> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>> ---
>>  mm/sparse-vmemmap.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>> index d3b718b..22620f6 100644
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -24,6 +24,7 @@
>>  #include <linux/module.h>
>>  #include <linux/spinlock.h>
>>  #include <linux/vmalloc.h>
>> +#include <linux/sched.h>
>>   
> 
> This is already in git.
> 
>     J
As I told in the 0th message, yes, I'm aware.
Just it does not seem to be in tglx's , so if people are willing to try
this out, they'll needed. Thus it's included in the series.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHNQjijYI8LaFUWXMRAn+UAJ48V1EyWoXkWu1+J0Y0ze59H7ZG2QCcDdgW
4qVJgJcQDfJrvZk8TSo901s=
=RwdO
-----END PGP SIGNATURE-----
