Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbXFLHjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbXFLHjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753217AbXFLHj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:39:29 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:2539 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbXFLHj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:39:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rapJX3FnVRtHqdo2oHHmKE/jHoQSlsVMTWRDESEBIh+3rG5YWci8m7j/qPORULF7mxCuLdnn1m1xKl6nopcA8m1p4HhlW2gNOWBPherOrY+O6zq1JgiJLb3PeKpmFznhN9JA/phgvBe4o5Ea9+YandKbnomA42/mXoujWiPG3wI=
Message-ID: <ea7e82ce0706120039n675a361emc214b2ecca964b75@mail.gmail.com>
Date: Tue, 12 Jun 2007 19:39:27 +1200
From: "Tobias Gerschner" <tobias.gerschner@gmail.com>
To: "Miguel Figueiredo" <elmig@debianpt.org>
Subject: Re: call for more SD versus CFS comparisons (was: Re: [ck] Mainline plans)
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
In-Reply-To: <466DE921.9030709@debianpt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466DE921.9030709@debianpt.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/6/12, Miguel Figueiredo <elmig@debianpt.org>:
> Hi all,
>
> some results based on massing_intr.c by Satoru, can be found on
> http://people.redhat.com/mingo/cfs-scheduler/tools/massive_intr.c
>


2007/6/12, Miguel Figueiredo <elmig@debianpt.org>:
> Hi all,
>
> some results based on massing_intr.c by Satoru, can be found on
> http://people.redhat.com/mingo/cfs-scheduler/tools/massive_intr.c

Hi,

Thanks for this reminder. I am gonna provide similar results if wanted
and useful for any dev.

However I took massiv_intr.c for a slightly different approach of
testing. The sole focus was responsiveness / (usable responsiveness
)of the desktop from the pov of an user.

I used massive_intr.c to bring the system to a state of lacking
usability ( overloaded system ) .

The setup was as follow:

mergedfb 2 monitors

Left desktop was displaying a music video playback using kaffeine /
xine at 100 % size. Right
Desktop had Firefox with 4 Tabs open 2 were text, 2 were graphical .

I did run massive_intr.c for 60 secs with increasing nproc (
10,20,30,40,50,60) waiting for effects.

Below a small table of the results

2.6.21.1-cfs-v16

nproc ,  usability result

10 , serious frame drops , Firefox  hardly recognizes clicked links,
but still usable
20 - 30, usability loss ( somehow under cfs firefox never finished
user requests like displaying web pages or opening new pages , no
feedback anymore, sudden changes on the desktop )
40 , sound skipping

2.6.21.1-ck2

nproc ,  usability result

10 - 20 , fine
30 - 50 , video frame drops , stair effect in playback
60 , unusable delay for responding to user actions ( clicking links ,
switching tabs )
70 , sound skipping

I know that this is still highly subjective but I tried to describe
the test procedure to make it as repeatable and simple as possible.
Furthermore tried to scale the user experience into numbers. I won't
even attempt to interpret those results but from an user point of view
the answer is crystal clear. It still remains -ck
. I performed this test 3 times and results are clearly the same.

As a sidenote . CK / SD seemed to be far more scalable in general. I
started designing a bit more complicated test scenario involving more
applications and opening new applications in a 2 minute timeframe. I
did this using -ck .

Once I booted into -cfs-v16 I realized that this test case was useless
because that test could simply not be performed because -cfs-v16 did
not even closely scale that well as -ck did.

I'll keep testing both schedulers ... .

Input, questions and feedback regarding the testing method are highly
appreciated.

The output of massive_intr can be found here :
http://www.yoper.com/scheduler-test/

kind regards

-- 
Tobias Gerschner
Member of Board of Yoper Linux Ltd. NZ

Knowing is not enough; we must apply. Willing is not enough; we must do.
