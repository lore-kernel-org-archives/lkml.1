Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYGLLF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYGLLF6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 07:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYGLLFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 07:05:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:59764 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYGLLFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 07:05:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lSy9QrQdeezqRu4FV0GSWNzr5XCk1vbpQpWxeCnlExGc5b55dc7+CMdeVENXyfkyJW
         6oebQmlfTbor723f0t9+hv0kxHBVSJSoegPrgn+u0zTXWTV8Ns6xZ4oQPeq69bqqKNDu
         WblxPQR+KdYPP24g+sCkUyViI/o1ekoh5bgHw=
Message-ID: <b647ffbd0807120405j3a0d28eaq26df8858b2ff3d3d@mail.gmail.com>
Date: Sat, 12 Jul 2008 13:05:49 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: miaox@cn.fujitsu.com
Subject: Re: current linux-2.6.git: cpusets completely broken
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Paul Menage" <menage@google.com>,
       "Max Krasnyansky" <maxk@qualcomm.com>, "Paul Jackson" <pj@sgi.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, rostedt@goodmis.org,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <487880D7.1040608@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080712031736.GA3040@damson.getinternet.no>
	 <alpine.LFD.1.10.0807112026390.2875@woody.linux-foundation.org>
	 <487880D7.1040608@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/12 Miao Xie <miaox@cn.fujitsu.com>:
> [ ... ]
>
> My explanation:
>        http://lkml.org/lkml/2008/7/7/75
> this bug occurred on the kernel compiled with CONFIG_CPUSETS=y.
>
> As Dmitry said in the following mail, modifying try_to_wake_up() to fix this bug
> is not perfect. Maybe we need update the sched domain before migrating tasks.
>        http://lkml.org/lkml/2008/7/7/94
>
> So I remake a patch to fix this bug by updating the sched domain when a cpu is in
> CPU_DOWN_PREPARE state.
>
> I think Vegard Nossum's patch is not so good because it is not necessary to detach
> all the sched domains when making a cpu offline.

(that was my "not so good" patch :-)

Yes, maybe. OTOH, your patch does it in a more drastic way which
should be analyzed more carefully.
Perhaps, for .27 but that's just my 2 cents.

Plus, rebuild_sched_domains() has to be called only for cpu-hotplug events.

(I guess it just shows once more that common_cpu_mem_hotplug_unplug()
should be re-designed a bit)


-- 
Best regards,
Dmitry Adamushko
