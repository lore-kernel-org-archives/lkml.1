Return-Path: <linux-kernel-owner+w=401wt.eu-S1755019AbZF3G62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbZF3G62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 02:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbZF3G6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 02:58:21 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:59290 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZF3G6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 02:58:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sQmguVpQBuzg6ZZ3vqLhHeYi0d5HwRDv478PTykTbXXHEWHITBVol3m04Px8I2iBU5
         sfGy58IKbx6Vo12zP3YwnwZz6QytdaGAw0vvWVsHh8qWEj0DCyfPW+pfCvVsF0YDijnp
         1YAxUmEZc4kXtv4TMATXvd6WSvaqPeWmntw3Y=
MIME-Version: 1.0
In-Reply-To: <20090630060031.GL7070@linux.vnet.ibm.com>
References: <20090625193137.GA16861@linux.vnet.ibm.com>
	 <alpine.DEB.1.10.0906291827050.21956@gentwo.org>
	 <1246315553.21295.100.camel@calx>
	 <alpine.DEB.1.10.0906291910130.32637@gentwo.org>
	 <1246320394.21295.105.camel@calx>
	 <20090630060031.GL7070@linux.vnet.ibm.com>
Date: Tue, 30 Jun 2009 09:58:22 +0300
X-Google-Sender-Auth: 55611e661da98a04
Message-ID: <84144f020906292358j6517b599n471eed4e88781a78@mail.gmail.com>
Subject: Re: [PATCH RFC] fix RCU-callback-after-kmem_cache_destroy problem in 
	sl[aou]b
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: paulmck@linux.vnet.ibm.com
Cc: Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, jdb@comx.dk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 9:00 AM, Paul E.
McKenney<paulmck@linux.vnet.ibm.com> wrote:
> On Mon, Jun 29, 2009 at 07:06:34PM -0500, Matt Mackall wrote:
>> On Mon, 2009-06-29 at 19:19 -0400, Christoph Lameter wrote:
>> > On Mon, 29 Jun 2009, Matt Mackall wrote:
>> >
>> > > This is a reasonable point, and in keeping with the design principle
>> > > 'callers should handle their own special cases'. However, I think it
>> > > would be more than a little surprising for kmem_cache_free() to do the
>> > > right thing, but not kmem_cache_destroy().
>> >
>> > kmem_cache_free() must be used carefully when using SLAB_DESTROY_BY_RCU.
>> > The freed object can be accessed after free until the rcu interval
>> > expires (well sortof, it may even be reallocated within the interval).
>> >
>> > There are special RCU considerations coming already with the use of
>> > kmem_cache_free().
>> >
>> > Adding RCU operations to the kmem_cache_destroy() logic may result in
>> > unnecessary RCU actions for slabs where the coder is ensuring that the
>> > RCU interval has passed by other means.
>>
>> Do we care? Cache destruction shouldn't be in anyone's fast path.
>> Correctness is more important and users are more liable to be correct
>> with this patch.
>
> I am with Matt on this one -- if we are going to hand the users of
> SLAB_DESTROY_BY_RCU a hand grenade, let's at least leave the pin in.

I don't even claim to understand all the RCU details here but I don't
see why we should care about _kmem_cache_destroy()_ performance at
this level. Christoph, hmmm?

                              Pekka
