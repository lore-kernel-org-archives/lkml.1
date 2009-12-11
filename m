Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbZLKRPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbZLKRPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 12:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZLKRPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 12:15:15 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:57988 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbZLKRPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 12:15:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=snNzb/HsARfgULOHi/HmUopyFZ4AeFoEmpifz3L2LfYTWRbTvhPkoEGeg4ShYM9Cku
         +UGYXBeJzIdT+vaC7p0JAAtn5zfpHGikU2kkDYYfc+349xfE49wk7EFcmDUx+rVu0qvd
         ubqJLbd85/UlyR/Qx+wdAOUDkhBNeq+owv/d0=
MIME-Version: 1.0
In-Reply-To: <x49ocm8nhn6.fsf@segfault.boston.devel.redhat.com>
References: <4b1a3d84.0d0db80a.39d0.ffff814a@mx.google.com>
	 <4e5e476b0912050313k280caa8bjf7c2cf1c5d19c88c@mail.gmail.com>
	 <4e5e476b0912060245x4d64300hb9689243bd712f2c@mail.gmail.com>
	 <x49ein6nx9k.fsf@segfault.boston.devel.redhat.com>
	 <4e5e476b0912081243ra071947if9a3edae77fb3861@mail.gmail.com>
	 <x49ocm8nhn6.fsf@segfault.boston.devel.redhat.com>
Date: Fri, 11 Dec 2009 18:15:20 +0100
Message-ID: <4e5e476b0912110915u209b8923m359d9147cc229fea@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: reduce write depth only if sync was delayed
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,
On Wed, Dec 9, 2009 at 7:09 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> The numbers look good. Now, there is no penalty in having low_latency
>> set for sequential writes, and just a small penalty for random ones.
>> The fact that random reads are faster with low_latency set is interesting.
>> Is the test is running with your patched tiobench (so that the number
>> of random operations is comparable with sequential ones)?
>
> No, I forgot all about that.  The number of random operations defaults
> to 4000, which is pretty low.  I'll re-run the tests with a number
> comparable to the sequential runs.  Sorry about that.
>
N.P.
if you have time, can you also re-run the test changing:
iosched/fifo_expire_async to 8 ?
I hope that reducing the expire_async, will make cfq quicker at switching
between the different threads, allowing more parallelism for seq
writers on your hw.
If this is the case, I think I can try to estimate the
fifo_expire_async in the autotuning patch.

> Cheers,
> Jeff
>

Thanks
Corrado
