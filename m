Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbXEMGLC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbXEMGLC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 02:11:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756979AbXEMGKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 02:10:54 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36056 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbXEMGKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 02:10:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yinghai.lu@sun.com
Subject: Re: [PATCH]x86_64: build and use GDT on copied compressed kernel
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
Date: Sun, 13 May 2007 00:09:59 -0600
In-Reply-To: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
	(Yinghai Lu's message of "Sat, 12 May 2007 22:33:14 -0700")
Message-ID: <m1ejllqmo8.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

> please check the patch.
>
> YH
>
> [PATCH]x86_64: build and use GDT on copied compressed kernel 
>
> Build and use GDT on copied compressed kernel postion, instead of using GDT 
> in data segment of loaded compressed kernel. Otherwise decompressing 
> compressed kernel image later in 64bit longmode, will overwrite GDT.

Overwriting the GDT should be fine because we don't reload the segments,
after we overwrite it.  GDT entries are only read when we load segments.
Interrupts are disabled so that should not cause a problem.

Why do you think the current behaviour is a problem?

Eric
