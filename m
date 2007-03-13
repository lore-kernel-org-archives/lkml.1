Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbXCMGXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbXCMGXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 02:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbXCMGXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 02:23:50 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:39428 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1753144AbXCMGXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 02:23:49 -0400
Date: Mon, 12 Mar 2007 22:00:51 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Lee Revell <rlrevell@joe-job.com>
cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
In-Reply-To: <75b66ecd0703121923q2f9913cdm8179122d95015ad8@mail.gmail.com>
Message-ID: <Pine.LNX.4.63.0703122152520.1855@qynat.qvtvafvgr.pbz>
References: <200703111457.17624.kernel@kolivas.org>  <200703130549.47058.kernel@kolivas.org>
  <1173730314.6431.30.camel@Homer.simpson.net>  <200703130738.19034.kernel@kolivas.org>
  <1173732344.6431.54.camel@Homer.simpson.net>  <Pine.LNX.4.63.0703121523220.1245@qynat.qvtvafvgr.pbz>
 <75b66ecd0703121923q2f9913cdm8179122d95015ad8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007, Lee Revell wrote:

> On 3/12/07, David Lang <david.lang@digitalinsight.com> wrote:
>> the problem comes when this isn't enough. if you have several CPU hogs on a
>> system, and they are all around the same priority level, how can the 
>> scheduler
>> know which one needs the CPU the most for good interactivity?
>> 
>> in some cases you may be able to directly detect that your high-priority 
>> process
>> is waiting for another one (tracing pipes and local sockets for example), 
>> but
>> what if you are waiting for several of them? (think a multimedia desktop 
>> waiting
>> for the sound card, CDRom, hard drive, and video all at once) which one 
>> needs
>> the extra CPU the most?
>
> I'm not an expert in this area by any means but after reading this
> thread the OSX solution of simply telling the kernel "I'm the GUI,
> schedule me accordingly" looks increasingly attractive.  Why make the
> kernel guess when we can just be explicit?

this can solve the specific problem (and since 'nice' is the natural way to tell 
the kernel this, it's not even a one-shot solution).

however Linus is right, the real underlying problem is where the user is 
waiting on a server. if this issue could be solved then a lot of things would 
benifit.

Con, as a quick hack (probably a bad idea as I'm not a scheduling expert), if a 
program blocks on another program (via a pipe or socket) could you easily give 
the rest of the first program's timeslice to the second one, without makeing it 
loose it's own?

I'm thinking that doing the dumb thing and just throwing a bit more CPU at the 
thing you are waiting for may work. (assuming that the server process actually 
does something useful with the extra CPU time it gets)

as far as latencies go, it would be like turning every process on the system 
into a cpu hog.

David Lang

> Does anyone know of a UNIX-like system that has managed to solve this
> problem without hooking the GUI into the scheduler?
>
> Lee
>
