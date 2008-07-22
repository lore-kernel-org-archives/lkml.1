Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbYGVFur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbYGVFur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759420AbYGVFuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:50:14 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:13066 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697AbYGVFuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:50:11 -0400
To: soohoon_lee@yahoo.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Question: queuing timer interrupts
From: Andi Kleen <andi@firstfloor.org>
References: <105452.56459.qm@web50711.mail.re2.yahoo.com>
Date: Tue, 22 Jul 2008 07:50:08 +0200
In-Reply-To: <105452.56459.qm@web50711.mail.re2.yahoo.com> (soohoon lee's message of "Mon, 21 Jul 2008 11:04:03 -0700 (PDT)")
Message-ID: <87wsje79in.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 Jul 2008 05:50:04.0637 (UTC) FILETIME=[CA0F40D0:01C8EBBE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

soohoon lee <soohoon_lee@yahoo.com> writes:

> There is a system and sometimes it should unavoidably block interrupts for critical jobs for couple of 10ms so will lost timer ticks.
> But keeping the wall clock is also critical.
> I thought about two solutions.
> 1. update wall clock when OS gets out of the critical section.
> 2. Add a hardware to count lost timer ticks, it's easy for this system.
>    So when the OS is able to process interrupts again, the hardware generates timer interrupts back to back to compensate lost ticks.

noidlehz should handle this all correctly already. You could just
treat your critical section like the idle loop and calling all the
timer hooks around it. The only subtle issue is that the delay should
not exceed the capability of the platform timer to tick without
overflow.

-Andi

