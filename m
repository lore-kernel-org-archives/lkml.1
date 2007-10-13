Return-Path: <linux-kernel-owner+w=401wt.eu-S1760598AbXJMBfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598AbXJMBfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 21:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbXJMBfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 21:35:46 -0400
Received: from sd-green-bigip-145.dreamhost.com ([208.97.132.145]:55885 "EHLO
	jankymail-a4.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754261AbXJMBfp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 21:35:45 -0400
Date: Fri, 12 Oct 2007 21:34:36 -0400
From: Gustavo Chain <g@0xff.cl>
To: Al Boldi <a1426z@gawab.com>
Cc: LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Reserve N process to root
Message-ID: <20071012213436.0b53fa23@0xff.cl>
In-Reply-To: <200710120929.10770.a1426z@gawab.com>
References: <200710120002.37341.a1426z@gawab.com>
	<200710120837.23586.a1426z@gawab.com>
	<4768FB5E-33D1-45B9-AA71-1D979F56B1B1@mac.com>
	<200710120929.10770.a1426z@gawab.com>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 12 Oct 2007 09:29:10 +0300
Al Boldi <a1426z@gawab.com> escribió:

> Kyle Moffett wrote:
> > On Oct 12, 2007, at 01:37:23, Al Boldi wrote:
> > > You have a point, and resource-controllers can probably control
> > > DoS a lot better, but the they also incur more overhead.  Think
> > > of this "lockout prevention" patch as a near zero overhead safety
> > > valve.
> >
> > But why do you need to add "lockout prevention" if it already
> > exists?
> 
> I said this before, but I'll say it again: it's about overhead!
> 
> > With CFS' extremely efficient per-user-scheduling (hopefully
> > soon to be the default) there are only two forms of lockout by non-
> > root processes:  (1) Running out of PIDs in the box's PID-space
> > (think tens or hundreds of thousands of processes), or (2) Swap-
> > storming the box to death.  To put it bluntly trying to reserve free
> > PID slots is attacking the wrong end of the problem and your so
> > called "lockout prevention" could very easily ensure that 10 PIDs
> > are available even if the user has swapstormed the box with the
> > PIDs he does have.
> 
> I think you are reading this wrong.  It's not about reserving PIDs,
> it's about exceeding the max-threads limit.  This limit is global and
> affects every user including root, which is good, as this allows the
> sysadmin to fence the system into a controllable state.  So once the
> system reaches the fence, sysadmin-intervention allows root to exceed
> the fence.
> 
> Again, this is much nicer with real resource-controllers, but again
> it's also more overhead.

Just an _if()_ ?

may be enable it as an option in kernel config ?

> 
> Thanks!
> 
> --
> Al
> 
> -
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Gustavo Chaín Dumit
Alumno de Ingeniería de Ejecución Informática
Pontificia Universidad Católica de Valparaiso
http://aleph.homeunix.com/~gchain
