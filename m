Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbZJEB7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbZJEB7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 21:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758215AbZJEB7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 21:59:43 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41351 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210AbZJEB7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 21:59:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Bryan Donlan <bdonlan@gmail.com>
Subject: Re: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Cc: kosaki.motohiro@jp.fujitsu.com,
       KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Timo Sirainen <tss@iki.fi>,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <3e8340490910041844w63720cfq7981c8f5364229de@mail.gmail.com>
References: <20091005103744.5F83.A69D9226@jp.fujitsu.com> <3e8340490910041844w63720cfq7981c8f5364229de@mail.gmail.com>
Message-Id: <20091005105617.5F86.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  5 Oct 2009 10:59:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Oct 4, 2009 at 9:38 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> The improvement idea is here.
> >>
> >> Changelog
> >>   - Added task_lock() to prctl(PR_SET_PROCTITLE_AREA)
> >>  -  Added small input sanity check to prctl(PR_SET_PROCTITLE_AREA)
> >
> > Doh, task_lock() is obviously wrong. please forget this.
> 
> As another note, in general I think we'd need to hold a lock over the
> entire operation. After all, if userspace changes its PROCTITLE_AREA,
> and then reuses the memory for something else, we have an information
> leak.

if reusing occur, it's obviously userland fault. I don't think we need to care this.
because current kernel also can be information leak by strcpy(argv[0], mypassword).

I think they are userland bug both.

 
> Perhaps a simpler approach would simply be to add a generation
> counter. Read it once at the start, barrier, then grab the title. Then
> at the end, read the generation counter again. If the value changed,
> we need to start over. Also, in this case, an error when reading the
> target process' memory should be ignored and retried, as we may have
> hit a race in which the target process unmapped the proctitle area
> after changing it.



