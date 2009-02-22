Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbZBVT11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbZBVT11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 14:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZBVT1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 14:27:19 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:41606 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbZBVT1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 14:27:18 -0500
Date: Sun, 22 Feb 2009 20:29:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Rakib Mullick <rakib.mullick@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, markus.t.metzger@gmail.com
Subject: Re: [PATCH -mm] tracing: Fix section mismatch in trace_hw_branches.c
Message-ID: <20090222192909.GA28401@uranus.ravnborg.org>
References: <b9df5fa10902131936p5e0997c6p57f659457a9cc356@mail.gmail.com> <20090221152251.GA6807@nowhere> <20090223010906.BD48.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223010906.BD48.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 01:15:08AM +0900, KOSAKI Motohiro wrote:
> > When I saw this patch, I searched the real purpose of __cpuinit and its
> > real impact.
> > But I didn't find any comments about it inside the kernel.
> 
> AFAIK, __cpuinit mean
> 
> if UP,                     __cpuinit == __init
> if SMP=Y && HOTPLUG_CPU=y, __cpuinit == "" (do nothing)
> if SMP=Y && HOTPLUG_CPU=n, __cpuinit == __init

A function annotated __cpuinit always end up in the same section these
days. And that section are then:

if HOTPLUG_CPU=y, __cpuinit => kept
if HOTPLUG_CPU=n, __cpuinit => discarded

SMP has no influence.

	Sam
