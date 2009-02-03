Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbZBCSmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbZBCSmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 13:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZBCSmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 13:42:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:13164 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbZBCSmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 13:42:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=f40zDg2kMGb303OjMD/4wXxrThKrIsVqW3Yy/k4OPyYRx4a3XNG0xBV8Sy9NAZXy6h
         X1qUQjOAQpf6cRC4ljlD0eCVSZCpAvpAmHlXLvXG3FXarB3PPMm5usJNUWtLysmYVggO
         WuDc0d25fTTI4ZMfUbJRZoczev5cFF2ERhEG4=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0902031217390.17910@qirst.com>
References: <20090114155923.GC1616@wotan.suse.de>
	 <20090123155307.GB14517@wotan.suse.de>
	 <alpine.DEB.1.10.0901261225240.1908@qirst.com>
	 <200902031253.28078.nickpiggin@yahoo.com.au>
	 <alpine.DEB.1.10.0902031217390.17910@qirst.com>
Date: Tue, 3 Feb 2009 20:42:04 +0200
X-Google-Sender-Auth: 9d889303af223632
Message-ID: <84144f020902031042i31eaec14v53a0e7a203acd28b@mail.gmail.com>
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

Hi Christoph,

On Tue, Feb 3, 2009 at 7:33 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
>> > Trimming through water marks and allocating memory from the page allocator
>> > is going to be very frequent if you continually allocate on one processor
>> > and free on another.
>>
>> Um yes, that's the point. But you previously claimed that it would just
>> grow unconstrained. Which is obviously wrong. So I don't understand what
>> your point is.
>
> It will grow unconstrained if you elect to defer queue processing. That
> was what we discussed.

Well, the slab_hiwater() check in __slab_free() of mm/slqb.c will cap
the size of the queue. But we do the same thing in SLAB with
alien->limit in cache_free_alien() and ac->limit in __cache_free(). So
I'm not sure what you mean when you say that the queues will "grow
unconstrained" (in either of the allocators). Hmm?

                               Pekka
