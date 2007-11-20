Return-Path: <linux-kernel-owner+w=401wt.eu-S1760074AbXKTG4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074AbXKTG4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759077AbXKTGzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:55:06 -0500
Received: from nz-out-0506.google.com ([64.233.162.237]:49448 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759582AbXKTGzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:55:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XFI8cGB/YWHKVQF3YrDPKOJaGrQerSl+dR1BI/Ybzhe+tXsG3ocUF7+jaw8F8HYb5cN0ccSxLWGkbHkjYphqGQzMh/r3ek9rwJGyMxQlsTDo8P00LpkVRLcCzFiNK8DkGsP1fq5N8yy1E7FOB5rIvhl3SSTW0E0fmqO9KDX/mAg=
Message-ID: <64bb37e0711192255j3fabd3d9g94544b3d518828a2@mail.gmail.com>
Date: Tue, 20 Nov 2007 07:55:02 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Milan Broz" <mbroz@redhat.com>
Subject: Re: 2.6.24-rc2-mm1: kcryptd vs lockdep
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Alasdair G Kergon" <agk@redhat.com>
In-Reply-To: <4741F97D.6090808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0711182323v1e2a1341tfc7f20df771b988@mail.gmail.com>
	 <20071119075627.GB28432@elte.hu>
	 <64bb37e0711191134l6dac07a2ie3b4258c43e1f1f0@mail.gmail.com>
	 <4741F97D.6090808@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 19, 2007 10:00 PM, Milan Broz <mbroz@redhat.com> wrote:
> Torsten Kaiser wrote:
> > Anything I could try, apart from more boots with slub_debug=F?

One time it triggered with slub_debug=F, but no additional output.
With slub_debug=FP I have not seen it again, so I can't say if that
would yield more info.

> Please could you try which patch from the dm-crypt series cause this ?
> (agk-dm-dm-crypt* names.)
>
> I suspect agk-dm-dm-crypt-move-bio-submission-to-thread.patch because
> there is one work struct used subsequently in two threads...
> (io thread already started while crypt thread is processing lockdep_map
> after calling f(work)...)

After reverting only
agk-dm-dm-crypt-move-bio-submission-to-thread.patch I also have not
seen the 'held lock freed' message again.

If it happens again with this revert, I will post that output.

Thanks for the hint.

Torsten
