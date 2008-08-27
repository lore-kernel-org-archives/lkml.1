Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYH0MwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYH0MwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 08:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbYH0MwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 08:52:10 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:54245 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbYH0MwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 08:52:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xpQfVR80pSFgZC1eMWKU76TI0ZgolvUMzhP5hV0AkURB/pDMjckwtQhXgkSLm54NCn
         IdcxsnP+Wm8f73doMdv22c5nwP4IkSfMYWUGFqxlBaxVO+f21SFRJ9nm7u4mGubAN7WE
         QbbG0IPJDru86osbVO2HCs1atf6kb7IU7PJds=
Message-ID: <f7848160808270552u2ee66167x912a68e0bf8b25bf@mail.gmail.com>
Date: Wed, 27 Aug 2008 08:52:06 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, linux-embedded@vger.kernel.org
In-Reply-To: <20080827092528.780916bd@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	 <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org>
	 <200808261111.19205.rusty@rustcorp.com.au>
	 <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
	 <20080826183051.GB10925@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>
	 <20080826205916.GB11734@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
	 <20080826232411.GC11734@cs181140183.pp.htv.fi>
	 <20080827092528.780916bd@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 4:25 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> You have a good point that aiming at 4kB makes 8kB a very safe choice.
>
> Not really no - we use separate IRQ stacks in 4K but not 8K mode on
> x86-32. That means you've actually got no more space if you are unlucky
> with the timing of events. The 8K mode is merely harder to debug.
>

By your logic though, XFS on x86 should work fine with 4K stacks -
many will attest that it does not and blows up due to stack issues.

I have first hand experiences of things blowing up with deep call
chains when using 4K stacks where 8K worked just fine on same
workload.

So there is definitely some other problem with 4K stacks.

Thanks
Parag
