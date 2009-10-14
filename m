Return-Path: <linux-kernel-owner+w=401wt.eu-S1761960AbZJNQPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761960AbZJNQPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761707AbZJNQPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:15:06 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:41785 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804AbZJNQPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:15:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=NzGW5q8cNgZdo4Ziz10BFbyTFhrqUk/MDySUJCoGvfh7CHgsA1/F6xMT0u3YUM8sFp
         siA0jlGLfk7NB0wrf9Pj5I5QXE8C6Pl7WGbiIc25q8rPl8sYkr8+HfiHyTRu+MiNJoRn
         Ns5Gc7yFrU+S+W6JsGGBEsnzJEktFbcGhsMco=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0910141154320.26476@gentwo.org>
References: <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0910131541290.7246@gentwo.org>
	 <alpine.DEB.1.00.0910131305440.3529@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0910131625370.13756@gentwo.org>
	 <alpine.DEB.1.00.0910131550050.15347@chino.kir.corp.google.com>
	 <20091014133457.GB5027@csn.ul.ie>
	 <alpine.DEB.1.10.0910141003590.9944@gentwo.org>
	 <20091014154944.GD5027@csn.ul.ie> <4AD5F3F8.8080603@cs.helsinki.fi>
	 <alpine.DEB.1.10.0910141154320.26476@gentwo.org>
Date: Wed, 14 Oct 2009 19:14:26 +0300
X-Google-Sender-Auth: 166d1240c0a60b82
Message-ID: <84144f020910140914u2c08655bjbd870019689ac947@mail.gmail.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu 
	operations in the hotpaths
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, David Rientjes <rientjes@google.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Wed, 14 Oct 2009, Pekka Enberg wrote:
>> SLAB is able to queue lots of large objects but SLUB can't do that because it
>> has no queues. In SLUB, each CPU gets a page assigned to it that serves as a
>> "queue" but the size of the queue gets smaller as object size approaches page
>> size.
>>
>> We try to offset that with higher order allocations but IIRC we don't increase
>> the order linearly with object size and cap it to some reasonable maximum.

On Wed, Oct 14, 2009 at 6:56 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> You can test to see if larger pages have an influence by passing
>
> slub_max_order=6
>
> or so on the kernel command line.
>
> You can force a large page use in slub by setting
>
> slub_min_order=3
>
> f.e.
>
> Or you can force a mininum number of objecxcts in slub through f.e.
>
> slub_min_objects=50
>
> slub_max_order=6 slub_min_objects=50
>
> should result in pretty large slabs with lots of in page objects that
> allow slub to queue better.

Yeah, that should help but it's probably not something we can do for
mainline. I'm not sure how we can fix SLUB to support large objects
out-of-the-box as efficiently as SLAB does.

                        Pekka
