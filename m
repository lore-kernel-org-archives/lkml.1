Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYCTCSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYCTCSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 22:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbYCTCSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 22:18:06 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:49619 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbYCTCSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 22:18:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CUwn/mqBe9MCoeB158rbnDAiTYlS+7bcC6YhzBmS/GBpi23n9sgZAQzanesZJOsYsYDQJTDHoDUn7nP19j1CLfQwWpgeEXAq6q9qN3IVtD/oFPSAgwGej3wmN7k2Hc6yWG0RbVCZ+oCmRb8fbp3fFvG/Nhkd9kcvdJmM357UneM=
Message-ID: <86802c440803191918y11af1269m39a7c7164f5f7d36@mail.gmail.com>
Date: Wed, 19 Mar 2008 19:18:01 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/79] smpboot integration
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, ak@suse.de
In-Reply-To: <20080319173533.GA31576@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12059475744092-git-send-email-gcosta@redhat.com>
	 <20080319173533.GA31576@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2008 at 10:35 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Glauber de Oliveira Costa <gcosta@redhat.com> wrote:
>
>  > Testing and bisectability:
>  >
>  > The end result was tested in all my hardware (which includes qemu ;-).
>  > It does not mean it will boot _your_ hardware, but I did my best ;-)
>  >
>  > The tree at least compiles in more than 20 randconfigs (for each of
>  > x86_64 and i386) For i386, each of the subarchitectures was compiled
>  > at least once. (By compile, I obviously mean, every patch,
>  > individually)
>
>  very nice work! I'll pick it up - and i'm not too worried about
>  breakages because at 80 patches granularity any problem should be
>  identifiable in a very finegrained way.
>

it broke 4 sockets quad core above with 64 bit

Booting processor 11/15 ip 6000
Initializing CPU#11
masked ExtINT on CPU#11
Calibrating delay using timer specific routine.. 4589.46 BogoMIPS (lpj=9178934)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 11/f -> Node 2
CPU: Physical Processor ID: 2
CPU: Processor Core ID: 3
CPU11: Quad-Core AMD Opteron(tm) Processor 8356 stepping 03
checking TSC synchronization [CPU#0 -> CPU#11]: passed.
Booting processor 12/16 ip 6000

looks like local apic id up 4 bit is masked out. so can not start 0x10
above any more.

YH
