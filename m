Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbYLMSpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbYLMSpb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 13:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYLMSpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 13:45:22 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:13248 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbYLMSpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 13:45:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QS1znTIAMY5m9sNSTImY0sIHBrEgSKiWQlfzKKASFgi2lhhIEqohbkQu5602MAtVdm
         lsQZYBdAOpeuM1H6yNL1fz3tBg0Qf7kxVO4FqhUnkq8qNHdYXsqWujC0AhRMiiR6uecW
         FqNSr/sJQDPu7cgzu1KrUD9Vd4goGUWiBS8XU=
Message-ID: <b637ec0b0812131045n34bf420w3729abf24533b51c@mail.gmail.com>
Date: Sat, 13 Dec 2008 19:45:18 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12155] Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
In-Reply-To: <T1gm2CtAHBF.A.bnH.14_QJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <u7kfEgp36eE.A.qpG.Y4_QJB@chimera>
	 <T1gm2CtAHBF.A.bnH.14_QJB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, Dec 13, 2008 at 5:33 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12155
> Subject         : Regression in 2.6.28-rc and 2.6.27-stable - hibernate related
> Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> Date            : 2008-11-23 16:17 (21 days old)
> References      : http://marc.info/?l=linux-kernel&m=122745709926361&w=4

Still present. It has been bisected to:

---------------------------------------------------------------------------------------------------------------
commit 5e55aa8db085dad1aabb4574c73c23c7ae571e7b
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Date:   Sun Oct 26 18:20:14 2008 -0400

    sched_clock: prevent scd->clock from moving backwards

    commit 5b7dba4ff834259a5623e03a565748704a8fe449 upstream

    sched_clock: prevent scd->clock from moving backwards

    When sched_clock_cpu() couples the clocks between two cpus, it may
    increment scd->clock beyond the GTOD tick window that __update_sched_clock()
    uses to clamp the clock.  A later call to __update_sched_clock() may move
    the clock back to scd->tick_gtod + TICK_NSEC, violating the clock's
    monotonic property.

    This patch ensures that scd->clock will not be set backward.

    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
    Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Cc: Chuck Ebbert <cebbert@redhat.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
------------------------------------------------------------------------------------------------------------

Both 2.6.27.8 and 2.6.28-rc8 with that commit reverted work fine
(well, at least they failed to show the bug so far).
