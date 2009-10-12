Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbZJLVQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbZJLVQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 17:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758193AbZJLVQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 17:16:35 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:38819 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758191AbZJLVQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 17:16:34 -0400
Date: Mon, 12 Oct 2009 17:08:58 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Real time kernel
In-Reply-To: <2d05c4580910121404x7d09ea3dvde1aa49b05d2e3fc@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0910121705090.28310@gentwo.org>
References: <2d05c4580910121100v702cbdddua9bd8de971fecaa2@mail.gmail.com>  <alpine.DEB.1.10.0910121615100.5363@gentwo.org> <2d05c4580910121404x7d09ea3dvde1aa49b05d2e3fc@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009, Dragoslav Zaric wrote:

> This is definition from http://rt.wiki.kernel.org/
>
> -------------------------------------------------------------------------
> Real-time applications have operational deadlines between some
> triggering event and the application's response to that event. To meet
> these operational deadlines, programmers use real-time operating
> systems (RTOS) on which the maximum response time can be calculated or
> measured reliably for the given application and environment.
> -------------------------------------------------------------------------

What is the calculated maximum response time in this case?

> So for specific requirements I would not say, you get slower kernel,
> you get purpose-making kernel, because on these kind of systems you
> probably do not do anything. It is probably the system that listens
> and responds to some events.

Ahh..

> Do you want to say, when using preemption in "normal user mode", Linux
> works slower then without preemption ?
> It makes sense,

Preemption increases code and data size of the kernel which causes the
processors to have to process more instructions and touch more cachelines
to do the same work.

> "because the latency of a task only depends on the tasks running at
> equal or higher priorities, all other tasks can be ignored."
> (http://rt.wiki.kernel.org/index.php/Frequently_Asked_Questions#What_is_real-time.3F)

Latency depends on the number of cachelines touched and on the number of
instructions that have to be processed by a processor until a reaction to
an event can occur. Increasing the latency by make processing more complex
can avoid outliers. You trade speed for guarantees in realtime OSes.


