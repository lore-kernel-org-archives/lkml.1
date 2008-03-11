Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbYCKKJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbYCKKJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 06:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbYCKKJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 06:09:26 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:54053 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbYCKKJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 06:09:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pVFXJVeRjmg60V/nLvgjbC5Un4nvsY6COFAW0TYMVNJ8fQAR1Y3+hwWalDQeQHLSo0faynqvDS7anC5YikzDkE5hZnonJh9ClJh0HfE4MAB79dGOkATw2qHvM3YtmG2ey+b9K13COy3yE0lo2FgjlKRungIXawbnnnMuXMT2eBs=
Message-ID: <b6fcc0a0803110309m1108382dm7b4aa714576ba813@mail.gmail.com>
Date: Tue, 11 Mar 2008 13:09:22 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 1/2] x86, fpu: split FPU state from task struct - v5
Cc: "Suresh Siddha" <suresh.b.siddha@intel.com>, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org, hch@infradead.org,
       linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@linux.intel.com>
In-Reply-To: <20080311083517.GC25110@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080310222955.565902000@linux-os.sc.intel.com>
	 <20080311050644.GB4589@martell.zuzino.mipt.ru>
	 <20080311083517.GC25110@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/08, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
> > > -	extern void __bad_fxsave_alignment(void);
> > > -
> > > -	if (offsetof(struct task_struct, thread.i387.fxsave) & 15)
> > > -	__bad_fxsave_alignment();
> >
> > I think removal of such checks needs giving necessary alignment to
> > cache. Previously it worked because of __aligned((16)) and
> > L1_CACHE_SHIFT combo.
>
> it's still checked, just elsewhere:
>
> > + WARN_ON((unsigned long)dst->thread.xstate & 15);
>
> i'd not expect us to ever align worse than 16 bytes in the future

But sysfs tells me alignment of "xstate" is 8 now. Object size is 512 which
is masking it.
