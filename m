Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbYL3Hmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbYL3Hmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 02:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbYL3HmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 02:42:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:35482 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbYL3Hl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 02:41:58 -0500
Subject: Re: [RFC][PATCH] Multimedia scheduling class
From: Peter Zijlstra <peterz@infradead.org>
To: Jussi Laako <jussi@sonarnerd.net>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4959198A.3020209@sonarnerd.net>
References: <4959198A.3020209@sonarnerd.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 30 Dec 2008 08:42:05 +0100
Message-Id: <1230622925.16718.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-29 at 20:40 +0200, Jussi Laako wrote:
> Hi,
> 
> I have created an experimental multimedia scheduling class (SCHED_MM)
> for use with multithreaded non-hardcore-realtime multimedia
> applications, such as ones based on gstreamer. These typically don't
> follow the determinism rules of well behaved SCHED_FIFO applications.
> However, these usually handle tasks like VoIP call audio processing,
> where somewhat lower scheduling latency is needed to obtain good user
> experience. Usually these are not very CPU-heavy and are mostly IO-bound
> processes. Thus, something between normal SCHED_OTHER and SCHED_FIFO is
> needed in a way where different threads of execution can set different
> kinds of scheduling parameters.
> 
> I have attached an initial version of my experimental patch for comments...

Sorry, I don't think this is a viable solution for anything.

This is typically the domain of soft-realtime, and as such would need a
realtime scheduling class -- using a proportional class like you did
just doesn't make sense for these tasks.

Eventually we'd hope to provide an sporadic task EDF based scheduler
with hard and soft realtime capabilities, but until that time, FIFO and
RR are the classes to use for anything realtime.

I'm not sure why you think SCHED_FIFO isn't good enough for your
applications, could you elaborate on that?

