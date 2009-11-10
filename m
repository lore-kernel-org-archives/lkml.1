Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbZKJAAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbZKJAAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 19:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbZKJAAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 19:00:33 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:30057 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZKJAAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 19:00:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KUmZ/gs2HjpO0k0i0pKkRO4snJnedJ4Tr7nKZxbA2ezwb/ebawc37n+VedRiaBVxrU
         QBdcOWVvbSiX6rUH0EEDxBfAo3c91Kmubf/IYAStiQNoTpC3MUhd8KyamHOnPvtB2HK5
         amzY/49ocWMB79VVHN5NN9yK8qD+5bcWQMfEQ=
MIME-Version: 1.0
In-Reply-To: <20091109144717.0cd17421.akpm@linux-foundation.org>
References: <20091103094703.GB11134@hack.redhat.com> <20091103230548.0B45.A69D9226@jp.fujitsu.com> 
	<20091104002544.0B4A.A69D9226@jp.fujitsu.com> <20091109144717.0cd17421.akpm@linux-foundation.org>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Mon, 9 Nov 2009 19:00:17 -0500
Message-ID: <3e8340490911091600v3a0e9b67r279349ac852d604a@mail.gmail.com>
Subject: Re: [PATCH v5] Added PR_SET_PROCTITLE_AREA option for prctl()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Americo Wang <xiyou.wangcong@gmail.com>, Timo Sirainen <tss@iki.fi>,
       Ulrich Drepper <drepper@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 9, 2009 at 5:47 PM, Andrew Morton <akpm@linux-foundation.org> wrote:

> What happens if userspace unmaps the memory after telling the kernel to
> use it?
>
> Will processes which try to read the command line get an error reading
> /proc?  If so, do all the commandline-reading programs in the world
> handle this in an appropriate fashion?

This case can already occur in the current code; the userspace process
would have to munmap() the top of its stack, but it certainly can do
so if it tries. In any case, access_process_vm() then returns 0
because of the fault, and thus /proc/pid/cmdline is seen to have zero
length. Since a zero-length /proc/pid/cmdline occurs with kernel
threads as well, we know this isn't a problem.
