Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbZIVNYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbZIVNYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZIVNYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:24:35 -0400
Received: from fifo99.com ([67.223.236.141]:42518 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711AbZIVNYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:24:34 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Daniel Walker <dwalker@fifo99.com>
To: Raistlin <raistlin@linux.it>
Cc: Peter Zijlstra <peterz@infradead.org>, claudio@evidence.eu.com,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <1253615424.20345.76.camel@Palantir>
References: <1253615424.20345.76.camel@Palantir>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 06:24:38 -0700
Message-Id: <1253625878.6575.34.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 12:30 +0200, Raistlin wrote:
> Hi Peter, Hi all,
> 
>     this is the implementation of a new scheduling class called 
>     SCHED_EDF made by me and Michael Trimarchi (CC:-ed). We followed the
>     suggestions you gave us at the multicore workshop in Kaiserlsautern
>     on October.
> 
> For other people: it is a real-time scheduling policy based on the
> Earliest Deadline First (EDF) algorithm, one of the most common
> real-time scheduling algorithms.

You've got some type of encoding corruption in your patch,

+       else {
+               if (!edf_task(p))
+                       p->sched_class =3D &fair_sched_class;
+               else
+                       p->sched_class =3D &edf_sched_class;
+       }
=20
        p->prio =3D prio;
=20

See the =20 , and =3D above.. I'm not sure exactly how that gets into
patches ;( We require utf8 encodings , some people can handle the stuff
above but most scripts and the patch command won't be able to. I realize
this is an RFC , so the next time you submit this try to make it utf8 ..

Daniel

