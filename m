Return-Path: <linux-kernel-owner+w=401wt.eu-S1766950AbXDST0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766950AbXDST0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766960AbXDST0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:26:05 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:29964 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766950AbXDST0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:26:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=US44ghyFLRVfqmSF/wQAz2cjQSi2PqlvkJpdrP0dIS/BFVyzpDvjFRjbnfFZCcgdhNSBbY7sW5yzU4aoZxyoqPMftQ+Xybi7pZ0pJRzvGorl+g/jIs1P+6gt0tyO7JfKeUUbs1wmZRMoFf+rSIz5nV3WlibxTH5VnUC/4QMpxU0=
Message-ID: <2c0942db0704191226t21d3dae1lb0fa99bcd9714cf2@mail.gmail.com>
Date: Thu, 19 Apr 2007 12:26:03 -0700
From: "Ray Lee" <madrabbit@gmail.com>
Reply-To: ray-gmail@madrabbit.org
To: "Con Kolivas" <kernel@kolivas.org>
Subject: Re: Renice X for cpu schedulers
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <npiggin@suse.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Matt Mackall" <mpm@selenic.com>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Mike Galbraith" <efault@gmx.de>, "ck list" <ck@vds.kolivas.org>,
       "Bill Huey" <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <200704192159.35546.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070417062621.GL2986@holomorphy.com>
	 <20070418221432.e4dbcf4f.akpm@linux-foundation.org>
	 <20070419063810.GA22418@elte.hu>
	 <200704192159.35546.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/07, Con Kolivas <kernel@kolivas.org> wrote:
> The one fly in the ointment for
> linux remains X. I am still, to this moment, completely and utterly stunned
> at why everyone is trying to find increasingly complex unique ways to manage
> X when all it needs is more cpu[1].
[...and hence should be reniced]

The problem is that X is not unique. There's postgresql, memcached,
mysql, db2, a little embedded app I wrote... all of these perform work
on behalf of another process. It's just most *noticeable* with X, as
pretty much everyone is running that.

If we had some way for the scheduler to decide to donate part of a
client process's time slice to the server it just spoke to (with an
exponential dampening factor -- take 50% from the client, give 25% to
the server, toss the rest on the floor), that -- from my naive point
of view -- would be a step toward fixing the underlying issue. Or I
might be spouting crap, who knows.

The problem is real, though, and not limited to X.

While I have the floor, thank you, Con, for all your work.

Ray
