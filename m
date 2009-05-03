Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbZECXZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbZECXZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbZECXZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:25:00 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:5853 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935AbZECXY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:24:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=E/3QuqoVRUFPibmSxjqaIBPY0m1Y2fHQzsqbnt91tRL0lTxWb6rjz/Rd3i3e4EDR8O
         J5Y1YS25Q9umILTIGNf90gJF9nUPuqg1xtNjtNnm/qwknwlSM3aMgCEEcufS40EmStWA
         kQFxhupYx+d1pf7TFUTjGR1E0pHCrB5lIxju8=
MIME-Version: 1.0
In-Reply-To: <49FDEFD1.8020608@nico22.de>
References: <49FDEFD1.8020608@nico22.de>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Sun, 3 May 2009 16:24:43 -0700
X-Google-Sender-Auth: d6d1f896cb752c8f
Message-ID: <2c0942db0905031624p350f37c8i1efa1b2654e7b7fe@mail.gmail.com>
Subject: Re: CFS not suitable for desktop computers
To: =?UTF-8?Q?Nico_Sch=C3=BCmann?= <spam@nico22.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 3, 2009 at 12:26 PM, Nico Schümann <spam@nico22.de> wrote:
> Dear Linux developers,
>
> I have been using Linux for some years now and for me, the best thing about
> 2.6 was that Linux ran desktop applications just smoothly. I was able to
> compile in the background, while all applications under X11 were just usable
> as if the machine was in idle mode. This was due to the priority of gcc
> being set to 30, for instance.
>
> Then, somewhere around 2.6.19 or 2.6.21, I do not remember exactly, the CFS
> was introduced, which removed all those "latency-based" scheduling policies.
> Now that I use 2.6.29 (I did not write earlier because I though it was a
> regression issue) I have to say: Linux is not as perfectly usable as before.
> End users do not want to experiment with nice levels and stuff, they just
> want that the system stays responsible even if there is a cpu-consuming
> process in the _background_. For me, this had been the greatest benefit from
> using Linux .
>
> Now what can we do, so that foreground applications are smoothly usable
> during hard cpu load? Is there any way to restore the old behaviour that
> cpu-consuming processes get a lower priority? It had always worked until
> this new scheduler was introduced.

My experience is exactly the opposite. Before CFS, my system was
completely unusable unless I manually controlled all nice levels in
the system for the big jobs. With CFS, everything just works, no
twiddling of nice levels necessary.

To get a useful response from the developers (who really do care about
latency issues), you should run a workload that causes unacceptable
behavior, and follow the suggestions below (taken from an old email
from Ingo Molnar):

----------
could you run this script while such a slowdown is really prominent:

 http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

and send me the output it generates? The output is the most useful if
you do this on a kernel that has CONFIG_SCHED_DEBUG=y and
CONFIG_SCHEDSTATS=y enabled.
----------

The problem may not be related to the scheduler at all, you realize,
but rather some other regression in another subsystem, such as the IO
scheduler or X or a driver, but hopefully the above script will be a
good starting point for those with the big brains to figure out what's
wrong.
