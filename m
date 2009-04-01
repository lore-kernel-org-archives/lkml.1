Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbZDADSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbZDADSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 23:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754522AbZDADSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 23:18:34 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:35767 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbZDADSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 23:18:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=drPQcggsl8eYJo0fmySgS1lX+xpbCLjNsABTQ1mzes/0aFdzpxGPpkSAru1ef48Ygr
         3VALSPty6GCAHn7v2etIluPZO22K/tvEhMOmvh8MYvLFElIlmtaUv8WoqntSLu8zIbtw
         xwh8QhmM0QVG6VLKUsqdLXg5klU+ihLWO3NpA=
MIME-Version: 1.0
In-Reply-To: <20090331185712.482877d6@hobbes>
References: <1238544647.8369.682.camel@gaiman.anholt.net>
	 <20090331171431.69ad044f@hobbes>
	 <7E82351C108FA840AB1866AC776AEC4657F48B3E@orsmsx505.amr.corp.intel.com>
	 <1238547790.27006.7743.camel@localhost.localdomain>
	 <20090331181251.46cf95b1@hobbes>
	 <1238549424.27006.7757.camel@localhost.localdomain>
	 <20090331185712.482877d6@hobbes>
Date: Wed, 1 Apr 2009 13:18:30 +1000
Message-ID: <21d7e9970903312018l1a74cfadoc6540dcda7fdeb53@mail.gmail.com>
Subject: Re: PAGE_CACHE_WC strikes again
From: Dave Airlie <airlied@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: suresh.b.siddha@intel.com,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 1, 2009 at 11:57 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Tue, 31 Mar 2009 17:30:24 -0800
> Suresh Siddha <suresh.b.siddha@intel.com> wrote:
>
>> On Tue, 2009-03-31 at 18:12 -0700, Jesse Barnes wrote:
>> > Right, the drm driver code went in before we had
>> > pgprot_writecombine. Now that it's available we should definitely
>> > use it.  I'm not sure about the set_memory_* routines though; we
>> > create io mappings in i915_dma.c at init time, and I thought we
>> > took care of things in i915_gem.c but we may need updates there.
>>
>> Jesse, yes i915_gem.c seems to be doing the right thing.
>>
>> What about various fault handlers in drm_vm.c like
>> drm_do_vm_shm_fault() etc. None of these fault handlers require
>> special attributes like wc/uc etc?
>
> Those are legacy.  I don't think they need anything changed...  Dave
> could correct me though.

Yeah just don't look at the top of drm_vm.c:drm_io_prot.

the attribute handling in there is one of the bits of the drm I hide away from.

and I think we can just move away from that with memory managed
drivers doing it properly.

Dave.
>
> --
> Jesse Barnes, Intel Open Source Technology Center
>
