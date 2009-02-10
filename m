Return-Path: <linux-kernel-owner+w=401wt.eu-S1751623AbZBJLyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbZBJLyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 06:54:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZBJLxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 06:53:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:36823 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbZBJLxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 06:53:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YKe+3J2jGNT9Wrnhj3lRJ6nKX5kQ3RjjHdpXFfcTBTUl4ja0o65qxow0RahmWPd+l8
         p5eEVxZ9JRs2ZVyDKJmRsd1RvEsP6aAUkUgfHSPJpEeeNiUlg9kUvh0zeePG5eA+bvtT
         qDnbrJlOQclN5UbljBMCzDzg9uh8ZaIaTmwYc=
MIME-Version: 1.0
In-Reply-To: <49914EE7.7030205@in.ibm.com>
References: <20090210194121.80256b72.sfr@canb.auug.org.au>
	 <49914790.6050008@in.ibm.com> <49914EE7.7030205@in.ibm.com>
Date: Tue, 10 Feb 2009 13:53:51 +0200
X-Google-Sender-Auth: 1fba0d009db8cd50
Message-ID: <84144f020902100353x4074f342ne4d61483074a06b7@mail.gmail.com>
Subject: Re: next Feb 10: mm/slqb build break
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: "Sachin P. Sant" <sachinp@in.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
       linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 11:54 AM, Sachin P. Sant <sachinp@in.ibm.com> wrote:
> Sachin P. Sant wrote:
>>
>> Hi Stephen,
>>
>> Todays next randconfig build on powerpc fails with
>>
>>  CC      mm/slqb.o
>> mm/slqb.c: In function __slab_free:
>> mm/slqb.c:1648: error: implicit declaration of function
>> slab_free_to_remote
>> mm/slqb.c: In function kmem_cache_open:
>> mm/slqb.c:2174: error: implicit declaration of function
>> kmem_cache_dyn_array_free
>> mm/slqb.c:2175: warning: label error_cpu_array defined but not used
>> mm/slqb.c: In function kmem_cache_destroy:
>> mm/slqb.c:2294: error: implicit declaration of function
>> claim_remote_free_list
>> mm/slqb.c: In function kmem_cache_reap_percpu:
>> mm/slqb.c:2547: error: implicit declaration of function
>> flush_remote_free_cache
>> mm/slqb.c: In function kmem_cache_init:
>> mm/slqb.c:2783: error: per_cpu__kmem_cpu_nodes undeclared (first use in
>> this function)
>> mm/slqb.c:2783: error: (Each undeclared identifier is reported only once
>> mm/slqb.c:2783: error: for each function it appears in.)
>> mm/slqb.c:2784: error: kmem_cpu_cache undeclared (first use in this
>> function)
>> make[1]: *** [mm/slqb.o] Error 1
>> make: *** [mm] Error 2
>
> CONFIG_SMP is not set hence the failure.

Actually, that's not the root cause here. You seem to have CONFIG_SMP
disabled but CONFIG_NUMA enabled. That's not possible on x86 which
makes me think it's a ppc kconfig bug. Hmm?

                                                     Pekka
