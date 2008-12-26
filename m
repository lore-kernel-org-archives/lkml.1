Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbYLZTmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbYLZTmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 14:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYLZTmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 14:42:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48052 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbYLZTmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 14:42:08 -0500
Message-ID: <4955338B.2010804@redhat.com>
Date: Fri, 26 Dec 2008 14:42:03 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: BUG or virtualbox issue?
References: <4954C095.3080300@xs4all.nl>
In-Reply-To: <4954C095.3080300@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel wrote:
> Hello,
> 
> Just started virtualbox for the first time on x86_64 Phenom system; is 
> this a kernel issue or something for the VirtualBox people?
> 
> Dec 26 12:20:01 surfplank2 kernel: BUG: using smp_processor_id() in 
> preemptible [00000000] code: VirtualBox/26774
> Dec 26 12:20:01 surfplank2 kernel: caller is RTMpCpuId+0x9/0x10 [vboxdrv]
> Dec 26 12:20:01 surfplank2 kernel: Pid: 26774, comm: VirtualBox Not 
> tainted 2.6.28 #3

Looks like the virtualbox code forgot to switch off
preemption before calling smp_processor_id().

This is broken, because the thread could get de-scheduled
and re-scheduled onto another CPU, which means the code
could end up using the wrong smp processor ID.

-- 
All rights reversed.
