Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbZBCSr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbZBCSr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 13:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZBCSrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 13:47:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:12515 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbZBCSru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 13:47:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=PkMK+U02lpOklrsf3i9B8y9f5lD9NcR8wtlos0TEM7vPzRdCR+AGBy886W5g9MSD7e
         4tf+dGPfb87+Ru9WeGBLF+/RzT/gb4k9511Sa99a2HTfy+pgy6RrvMaCLbqK5Hg7OXmZ
         mRinuQtvf47F0vWucUYrBt7tgqpmsL4J36wjM=
MIME-Version: 1.0
In-Reply-To: <84144f020902031042i31eaec14v53a0e7a203acd28b@mail.gmail.com>
References: <20090114155923.GC1616@wotan.suse.de>
	 <20090123155307.GB14517@wotan.suse.de>
	 <alpine.DEB.1.10.0901261225240.1908@qirst.com>
	 <200902031253.28078.nickpiggin@yahoo.com.au>
	 <alpine.DEB.1.10.0902031217390.17910@qirst.com>
	 <84144f020902031042i31eaec14v53a0e7a203acd28b@mail.gmail.com>
Date: Tue, 3 Feb 2009 20:47:48 +0200
X-Google-Sender-Auth: f5ec21bd8edc2f9c
Message-ID: <84144f020902031047o2e117652w28886efb495688c4@mail.gmail.com>
Subject: Re: [patch] SLQB slab allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 3, 2009 at 8:42 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>> It will grow unconstrained if you elect to defer queue processing. That
>> was what we discussed.
>
> Well, the slab_hiwater() check in __slab_free() of mm/slqb.c will cap
> the size of the queue. But we do the same thing in SLAB with
> alien->limit in cache_free_alien() and ac->limit in __cache_free(). So
> I'm not sure what you mean when you say that the queues will "grow
> unconstrained" (in either of the allocators). Hmm?

That said, I can imagine a worst-case scenario where a queue with N
objects is pinning N mostly empty slabs. As soon as we hit the
periodical flush, we might need to do tons of work. That's pretty hard
to control with watermarks as well as the scenario is solely dependent
on allocation/free patterns.
