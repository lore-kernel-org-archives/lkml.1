Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbYGLXFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbYGLXFk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 19:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbYGLXFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 19:05:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:57170 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbYGLXFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 19:05:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dIeXgdqYwOIcCKW8iCsm3ItX/isv4+aH4Tg0sFysWQuQqfWsDw64ZwjiTVMuD3DUpz
         oIo2NqpAgcrn/u+id+GBvZHcJFyN1Ba1lzW6E31xen1PjgQX4exYtmXjblrIV+2yTYd8
         QjteTb8y+uv9T3vVhj/qbbkezw7D6mPeZ7wnk=
Message-ID: <b647ffbd0807121605y5caa4023v6578cfb17de103e3@mail.gmail.com>
Date: Sun, 13 Jul 2008 01:05:23 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: current linux-2.6.git: cpusets completely broken
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Paul Menage" <menage@google.com>,
       "Max Krasnyansky" <maxk@qualcomm.com>, "Paul Jackson" <pj@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, miaox@cn.fujitsu.com,
       rostedt@goodmis.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0807121600l653e28bfwb5cce2d880b7f2cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080712031736.GA3040@damson.getinternet.no>
	 <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>
	 <b647ffbd0807120304o7a500dc9oce761e51c9dce908@mail.gmail.com>
	 <alpine.LFD.1.10.0807121254490.2875@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807121411350.2875@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0807121504010.2959@woody.linux-foundation.org>
	 <19f34abd0807121600l653e28bfwb5cce2d880b7f2cd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/13 Vegard Nossum <vegard.nossum@gmail.com>:
> O Master Penguin,
>
> On Sun, Jul 13, 2008 at 12:07 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> Assuming I didn't do anythign stupid, of course, which is why it would
>> definitely need much more testing. And especially if Vegard can test it
>> with the case that oopsed for him due to the bad migration..
>
> Your patch has been tested and found to be working!

Are you sure that you have removed my patch or the one from Miao? I
would be really surprised if this patch works without them. Linus has
updated sched_migrate_task() which is used _only_ by sched_exec() ---
this is not the path that leads to this bug. try_to_wake_up() -> ...
-> wake_idle() does not see "cpu_active_map".

>
> Vegard
>

-- 
Best regards,
Dmitry Adamushko
