Return-Path: <linux-kernel-owner+w=401wt.eu-S932828AbXKOUYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbXKOUYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762023AbXKOUY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:24:27 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:55306 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665AbXKOUY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:24:26 -0500
Date: Thu, 15 Nov 2007 12:24:25 -0800
From: Micah Dowty <micah@vmware.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>
Subject: Re: High priority tasks break SMP balancer?
Message-ID: <20071115202425.GC4914@vmware.com>
References: <20071109223417.GB16250@vmware.com> <4734F397.7080802@gmx.net> <20071110001103.GD16250@vmware.com> <2FAA6826-653E-482F-A037-C539BAEEA1DA@mac.com> <20071115191408.GA4914@vmware.com> <Pine.LNX.4.64.0711151206370.28639@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711151206370.28639@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 12:07:47PM -0800, Christoph Lameter wrote:
> On Thu, 15 Nov 2007, Micah Dowty wrote:
> 
> > For reference, the exact test I used with git-bisect is attached. The
> > C program (priosched) starts two busy-looping threads and a
> > high-priority high-frequency thread which uses relatively little
> > CPU. The Python program repeatedly starts the C program, runs it for a
> > half second, and measures the resulting imbalance in CPU usage. On
> > kernels prior to the above commit, this reports values within about
> > 10% of 1.0. On later kernels, it crashes within a couple iterations
> > due to a divide-by-zero error :)
> 
> The kernel crashes? Sounds like your application crashes with a divide by 
> zero?

Yes, the Python test harness crashes, not the kernel. It's just
because on a kernel which exhibits this SMP balancer bug, within a
couple of test iterations I'll hit a case where cpu1 was almost
totally idle and the test harness divides by zero when calculating the
imbalance.

--Micah
