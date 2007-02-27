Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbXB0Uks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbXB0Uks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbXB0Uks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:40:48 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:40364 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbXB0Ukr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:40:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hzkg2MGDGZmmASfjZL9E9OrWaIJGqh2qJU1RfwELZHHnla9YLc9GD1+3ndFBQ54YtK0mkIol2Iw0UMiVv26X40bfN6qYGrv6KXfjwQYeQXZKP430szUTZ6NpIes6ER1c+oLhpkHPm9x0yAAaP/+qZoJbIr/0D2sT8A9jrksPXWc=
Message-ID: <29495f1d0702271240p1f446a74me9623ae756c67eb5@mail.gmail.com>
Date: Tue, 27 Feb 2007 12:40:45 -0800
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Paulo Marques" <pmarques@grupopie.com>
Subject: Re: SMP performance degradation with sysbench
Cc: "Rik van Riel" <riel@redhat.com>,
       "=?ISO-8859-1?Q?\"J.A._Magall=F3n\"?=" <jamagallon@ono.com>,
       "Hiro Yoshioka" <hyoshiok@miraclelinux.com>, davej@redhat.com,
       harlan@artselect.com, nickpiggin@yahoo.com.au, l_allegrucci@yahoo.it,
       linux-kernel@vger.kernel.org, mingo@elte.hu, suparna@in.ibm.com,
       jens.axboe@oracle.com
In-Reply-To: <45E4469C.8000505@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070226223645.GA24174@redhat.com>
	 <98df96d30702261632u7479c9b2sce93f80f68bbc8d0@mail.gmail.com>
	 <45E37EA3.3060101@redhat.com>
	 <20070227.130305.424251739.hyoshiok@miraclelinux.com>
	 <45E3B421.603@redhat.com> <20070227091409.6f3d12f9@werewolf-wl>
	 <45E439E4.5030703@redhat.com> <45E4469C.8000505@grupopie.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/07, Paulo Marques <pmarques@grupopie.com> wrote:
> Rik van Riel wrote:
> > J.A. Magallón wrote:
> >>[...]
> >> Its the same to answer 4+4 queries than 8 at half the speed, isn't it ?
> >
> > That still doesn't fix the potential Linux problem that this
> > benchmark identified.
> >
> > To clarify: I don't care as much about MySQL performance as
> > I care about identifying and fixing this potential bug in
> > Linux.
>
> IIRC a long time ago there was a change in the scheduler to prevent a
> low prio task running on a sibling of a hyperthreaded processor to slow
> down a higher prio task on another sibling of the same processor.
>
> Basically the scheduler would put the low prio task to sleep during an
> adequate task slice to allow the other sibling to run at full speed for
> a while.
>
> I don't know the scheduler code well enough, but comments like this one
> make me think that the change is still in place:

<snip>

> If that is the case, turning off CONFIG_SCHED_SMT would solve the problem.

To chime in here, I was attempting to reproduce this on an 8-way Xeon
box (4 dual-core). SCHED_SMT and SCHED_MC on led to scaling issues
when above 4 threads (4 threads was the peak). To the point, where I
couldn't break 1000 transactions per second. Turning both off (with
2.6.20.1) gives much better performance through 16 threads. I am now
running for the cases from 17 to 32 to see if I can reproduce the
problem at hand. I'll regenerate my data and post numbers soon.

I don't know if anyone else has those on in their kernel .config, but
I'd suggest turning them off, as Paulo said.

Thanks,
Nish
