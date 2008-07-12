Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbYGLWIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbYGLWIc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 18:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbYGLWIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 18:08:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbYGLWIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 18:08:24 -0400
Date: Sat, 12 Jul 2008 15:07:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: Vegard Nossum <vegard.nossum@gmail.com>, Paul Menage <menage@google.com>,
       Max Krasnyansky <maxk@qualcomm.com>, Paul Jackson <pj@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: current linux-2.6.git: cpusets completely broken
In-Reply-To: <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org>
References: <20080712031736.GA3040@damson.getinternet.no>  <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org> <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com> <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>
 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Jul 2008, Linus Torvalds wrote:
> 
> This patch almost certainly doesn't work, but let me explain:

Well, I decided to just take the plunge and test it. It WorksForMe(tm), so 
it's no _totally_ broken. But I really didn't test it except to see that 
it still booted, and I don't use cpusets and never saw the original bug, 
of course.

But considering how simple it is, if it works for people as a way to work 
around stupid CPU migration issues due to subtle wakeup calls, I'd almost 
prefer to really solve this whole issue with that cpu_active_map thing. 

It's so simple it should be really _robust_ in the presense of problems 
elsewhere (like the whole cpusets scheduling domain mess).

Assuming I didn't do anythign stupid, of course, which is why it would 
definitely need much more testing. And especially if Vegard can test it 
with the case that oopsed for him due to the bad migration..

		Linus
