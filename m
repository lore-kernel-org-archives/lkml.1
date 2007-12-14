Return-Path: <linux-kernel-owner+w=401wt.eu-S933435AbXLNW1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435AbXLNW1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbXLNW1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 17:27:46 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:1965 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbXLNW1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 17:27:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nu1i8E6H4RxMIbkrdF/CwKeMJJ1/3Eju4sH+mYY+yiu09sRZKj1maq5MetPCOKItsFYovCiQXREJcKtCi5oHpQjrLWM1VX65iSDz0iGH4JpO1YfCmf8LijCy6OSfUQ0Z01H6lR2M2T69x6VS9xd2qwB2e9tv/Gy8v6EdbXg7eFg=
Message-ID: <21d7e9970712141427h25c84e9g76237a93e634fa76@mail.gmail.com>
Date: Sat, 15 Dec 2007 08:27:44 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [RFC PATCH 00/12] PAT 64b: PAT support for X86_64
Cc: "Dave Airlie" <airlied@skynet.ie>, venkatesh.pallipadi@intel.com,
       ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, davej@redhat.com,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071214220015.GD717@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213235543.568682000@intel.com>
	 <alpine.DEB.0.82.0712140023550.27550@skynet.skynet.ie>
	 <20071214220015.GD717@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 15, 2007 8:00 AM, Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
> On Fri, Dec 14, 2007 at 12:28:25AM +0000, Dave Airlie wrote:
> > Yes, the main use for GPUs is to have RAM pages mapped WC, and placed into
> > a GART on the GPU side, currently for Intel IGD we are okay as the CPU can
> > access the GPU GART aperture, but other chips exist where this isn't
> > possible, I think poulsbo and possible some of the AMD IGPs..
>
> Ok. So how is it working today on these platforms with no PAT support.
> Open source drivers use UC or WB on these platforms? As this RAM is not
> contiguous, one can't use MTRRs to set WC. Right?
>
> Well, if WC is needed for RAM, then we have to address it too.
>

It doesn't work really, which is mostly the problem :)

We mostly use UC on these pages, or WB within cache coherent domains.
mtrrs are totally useless in this situation.

Dave.
