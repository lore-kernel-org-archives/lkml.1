Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbYHFUec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbYHFUec (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762279AbYHFUbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:31:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37933 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761287AbYHFUbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:31:19 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5355"; a="5203787"
Message-ID: <489A0A16.8060802@qualcomm.com>
Date: Wed, 06 Aug 2008 13:31:18 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Peter Oruba <peter.oruba@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/5] [PATCH 3/5] x86: Run Intel ucode-updates via workqueue.
References: <20080806152117.198754464@amd.com>	<20080806152319.773811325@amd.com> <20080806084446.68683aaf@infradead.org>
In-Reply-To: <20080806084446.68683aaf@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 6 Aug 2008 17:21:20 +0200
> Peter Oruba <peter.oruba@amd.com> wrote:
> 
> [ no description or reason ]
> 
> Why is this?
> 
> I'm not very happy about this.. it means practically that this stuff
> *has* to run late. Probably later than we want to.
> (Like.. we may want to redo the microcode during resume.. which is
> not a schedulable context)

Dmitry and I tried to figure out how soon does it need to run.
Nobody had a strong argument why it must run synchronously in the 
hotplug path. Sure we want it as soon as possible and I'd say workqueue 
is soon enough.
Existing hotplug path does not guaranty any ordering and original 
microcode interface was driven from user-space. So clearly it was not 
considered very critical.

Max
