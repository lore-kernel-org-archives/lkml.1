Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbZLWLfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbZLWLfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 06:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbZLWLft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 06:35:49 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:55875 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbZLWLfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 06:35:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=P8dQC2KOBhTWikHCCl+3dzZavJG/zLjNmMu7buRc9FxDBdvw5UFI+wOsTtvCfIuoj2
         eWDRa2w5HQ7EtKh6O1EORjVF7Bx44BhdcERRqTKQWpYgxa243YjnSSCE0EXLFUb7Ya2k
         NXD/R4cEjjkTpRGVwskUSLvpqivBvbGhxnf3g=
MIME-Version: 1.0
In-Reply-To: <1261565584.4937.124.camel@laptop>
References: <b9df5fa10912230214s3815c023g2a7e7ca152eb00e4@mail.gmail.com>
	 <1261563687.4937.120.camel@laptop>
	 <b9df5fa10912230246w4adf160bibc12d7c6480ce058@mail.gmail.com>
	 <1261565584.4937.124.camel@laptop>
Date: Wed, 23 Dec 2009 17:35:48 +0600
Message-ID: <b9df5fa10912230335r459f86d4te868fca82b891752@mail.gmail.com>
Subject: Re: SCHED: Is task migration necessary in sched_exec().
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/09, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2009-12-23 at 16:46 +0600, Rakib Mullick wrote:
>  > On 12/23/09, Peter Zijlstra <peterz@infradead.org> wrote:
>  > > On Wed, 2009-12-23 at 16:14 +0600, Rakib Mullick wrote:
>
> There is no overloaded task, its the runqueue that is overloaded wrt to
>  other runqueues. The load-balancer has to pick a 'random' task and pray.

By saying overloaded task - I didn't want to mean any perticular task.
I wanted to mean a runqueue of excessive tasks with regard to other
runqueue (sorry for misleading you).

>  Current heuristics try to pick a task that hasn't been on the cpu for a
>  while, because for those the effective cache footprint is minimal.
>
Yes - current heuristics does this - to make sure that it doesn't have to
wait too long. It pushes process into another runqueue (probably less loaded)
just to make sure that - it will get the CPU a bit quickly. But when a task
got the CPU - we should keep it out of equation. The point of moving task
is - it have to wait less. At exec current task don't have to wait to get CPU.

>  > Why the _current_ task?
>
>  Because at exec it has effective 0 cache footprint, and is thus an ideal
>  victim to move about.
>
>
>
