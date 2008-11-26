Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbYKZBJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbYKZBJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 20:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYKZBJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 20:09:33 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51485 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYKZBJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 20:09:32 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] Poll : introduce poll_wait_exclusive() new function
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       ltt-dev@lists.casi.polymtl.ca,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Davide Libenzi <davidel@xmailserver.org>
In-Reply-To: <alpine.DEB.1.10.0811251316590.32523@alien.or.mcafeemobile.com>
References: <20081125194700.26EB.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.1.10.0811251316590.32523@alien.or.mcafeemobile.com>
Message-Id: <20081126100749.3CAC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 26 Nov 2008 10:09:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Mathieu Desnoyers explained it cause following problem to LTTng.
> > 
> >    In LTTng, all lttd readers are polling all the available debugfs files
> >    for data. This is principally because the number of reader threads is
> >    user-defined and there are typical workloads where a single CPU is
> >    producing most of the tracing data and all other CPUs are idle,
> >    available to consume data. It therefore makes sense not to tie those
> >    threads to specific buffers. However, when the number of threads grows,
> >    we face a "thundering herd" problem where many threads can be woken up
> >    and put back to sleep, leaving only a single thread doing useful work.
> 
> Why do you need to have so many threads banging a single device/file?
> Have one (or any other very little number) puller thread(s), that 
> activates with chucks of pulled data the other processing threads. That 
> way there's no need for a new wakeup abstraction.

Mathieu, I don't hope I unstrictly explain to LTTng.
Could you please explain LTTng design?



