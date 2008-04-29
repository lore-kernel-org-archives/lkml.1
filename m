Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbYD2ToX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbYD2ToX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYD2ToP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:44:15 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:61511 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYD2ToO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:44:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=aKEw9SlJXqgtHj62OAmh79XZT2Tfl7u0YOrmkJ9cbZaXC7piimPcAeiBxXSIi1GQsG1p67tStR+6UBs4/Ej+cH4qw9d9dcQuywbeo+yUwQ2UOD/FPe1uram7cORYlNkfR8mVkI4V+ZZvFSieKRR1ihhOqU6FUBBlXB/GmV4ikXM=
Message-ID: <86802c440804291244r502a2d3cla12610a35a0d973b@mail.gmail.com>
Date: Tue, 29 Apr 2008 12:44:07 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Gabriel C" <nix.or.die@googlemail.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>, balajirrao@gmail.com
In-Reply-To: <m18wyw31v4.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
	 <200801221623.20861.yinghai.lu@sun.com>
	 <20080426035614.a30afb17.akpm@linux-foundation.org>
	 <48132665.8050202@googlemail.com>
	 <86802c440804261805rc739f9as519213fecdc0cdff@mail.gmail.com>
	 <m17ieh4zuo.fsf@frodo.ebiederm.org> <20080429103150.GJ23198@elte.hu>
	 <m1ej8o4liv.fsf@frodo.ebiederm.org>
	 <86802c440804291140k7e96b6cftbb350b8fc72103f@mail.gmail.com>
	 <m18wyw31v4.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 12:19 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
>
> >>  The potential problem isn't while we reprogram the MTRRs, the potential
>  >>  problem is mapping the SMM area uncachable.  In which case we will
>  >>  make each SMM interrupt drastically slower.  Which can have all kinds of
>  >>  unpleasant side effects.
>  >
>  > and ACPI area too.
>
>  True but at least that one is visible.
>
>
>  > that only try to make the continuous to discrete layout. and still try
>  > to cover all that is (WBs - UC) directly with WB.
>  > only thing is that could run out of MTRR..., and mtrr_gran_size is
>  > used to avoid that.
>  > then some RAM that is less than mtrr_gran_size could be dumped.
>  > so mtrr_gran_size could do sth.
>  > anyway this patch only can meet one end.
>  > for example Mika Fischer's system doesn't need to trim any RAM in MTRR.
>  > but for Gabriel's system may need to trim some RAM in MTRR.
>
>  Right.  Ram trimming (changing memory from WB to UC) is the potential
>  problem.
>
>  See my other post, in short I think we can address safely address all
>  of the systems where the only problem is the selection of MTRRs by the
>  BIOS.

BIOS should provide the selection...

>
>  Then have an option (mtrr_chunk_size) for RAM trimming that is
>  off by default.

Yes. there is CONFIG option and boot command line to enable it.

YH
