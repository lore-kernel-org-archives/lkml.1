Return-Path: <linux-kernel-owner+w=401wt.eu-S1761038AbZANJCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761038AbZANJCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbZANJCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:02:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:27098 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbZANJCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:02:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=pnRzCncwc80MqLvK4K+5TQ+cJ1zHPo3uT3TJ0XdnYnCbdKM/ATPkTprQyK8k2UoqhO
         wAlYAYN0GFTXpIreD8pNDuznjWGcqV+7pJbVQD0mXIoWNjacCchnIBRySl1lWdhNxAYf
         y8fezS04llwhOykXO2Vqxg/QcnyLJQumeIUQU=
Message-ID: <84144f020901140102y57070c06r8133533c001d092e@mail.gmail.com>
Date: Wed, 14 Jan 2009 11:02:14 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
Cc: "Manfred Spraul" <manfred@colorfullife.com>, krh@redhat.com,
       stefanr@s5r6.in-berlin.de, dcm@acm.org, Nadia.Derbey@bull.net,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       paulmck@us.ibm.com, stable@kernel.org
In-Reply-To: <20090114001745.9575ab02.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231571060.3538.18.camel@localhost.localdomain>
	 <20090110011557.9d94e111.akpm@linux-foundation.org>
	 <496872E0.9030007@s5r6.in-berlin.de>
	 <1231773620.6365.21.camel@gaara.bos.redhat.com>
	 <496B9FC7.3090108@colorfullife.com>
	 <1231792712.6365.31.camel@gaara.bos.redhat.com>
	 <496BAD1C.5060201@colorfullife.com>
	 <20090113144802.39dc4c23.akpm@linux-foundation.org>
	 <84144f020901132319g50dc9e50o283b0d263f287eea@mail.gmail.com>
	 <20090114001745.9575ab02.akpm@linux-foundation.org>
X-Google-Sender-Auth: 73172d77a7446282
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 12:48 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>> >> If the idr code passes uninitialized objects to kmem_cache_free(), then
>> >> the next kmem_cache_alloc will return a bad object.
>> >>
>> >
>> > None of this got us much closer to fixing the bug ;)
>> >
>> > What do we think of just removing the constructor and using
>> > kmem_cache_zalloc()?

On Wed, 14 Jan 2009 09:19:01 +0200 "Pekka Enberg"
<penberg@cs.helsinki.fi> wrote:
>> Why do I get the feeling that we have merged a similar patch before?

On Wed, Jan 14, 2009 at 10:17 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Dunno - maybe we had the same bug in other places.

It's probably commit 571817849c76aabf34d534c905b5e604f2e824c5 ("msi:
use kmem_cache_zalloc()"). But the changelog is bit, uhm, limited on
the subject... oh well.

                             Pekka
