Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbYA2EGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbYA2EGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 23:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYA2EFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 23:05:55 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62560 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbYA2EFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 23:05:54 -0500
Date: Mon, 28 Jan 2008 20:12:46 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] x86: add PCI IDs to k8topology_64.c
In-reply-to: <p73y7a970nd.fsf@bingen.suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Joachim Deguara <joachim.deguara@amd.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       Dean Roe <roe@cray.com>
Message-id: <200801282012.47190.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801281211.28214.joachim.deguara@amd.com>
 <p73y7a970nd.fsf@bingen.suse.de>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008 07:48:06 pm Andi Kleen wrote:
> "Joachim Deguara" <joachim.deguara@amd.com> writes:
> 
> > Quick history, this is a harmless patch that got dropped by Andi as a mixup to 
> 
> It's not harmless.
> 
> > dropping another patch of mine that was made obsolete by Yinghai.
> > http://thread.gmane.org/gmane.linux.kernel/559581
> 
> No that's not the correct history. The correct history is that 
> I intentionally rejected this patch because the old k8topology
> hack should really not be used anymore on modern machines (especially
> not on Quad Cores). SRAT is the far better way to handle this problem
> because it has a proper abstraction.
> 
> The problem with k8topology.c is that it needs to know very low level
> information (like HT node numbers etc.) the kernel should not really
> need to know and which are difficult to handle generally without
> motherboard specific knowledge. 
> 
> k8topology.c mostly guesses, which was never a good way to handle this. 
> Also in in the various "node has no memory" cases it needs quite
> hackish fallback heuristics which will be always fragile. Then there
> are some ugly interactions with quad cores. And some other issues
> 
> I still think the patch a bad idea because adapting this file all
> the time is a long term maintenance issue. I can say that as 
> the original author :-) It was just a quick hack long ago
> to get NUMA going early. But now it far outlived its usefulness
> and adapting it to modern machines is the wrong direction. 
> 
> Best is to phase k8topology out.

then with acpi=off, we can not use numa any more.

also there are some users are using LinuxBIOS or other firmware that doesn't have  or like ACPI support. but they still need numa.
for them ACPI doesn't help.

YH

