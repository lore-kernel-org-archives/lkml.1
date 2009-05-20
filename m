Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbZETTAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbZETTAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 15:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbZETS74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:59:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52373 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbZETS7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:59:55 -0400
Date: Wed, 20 May 2009 14:59:54 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: GeunSik Lim <leemgs1@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       tglx <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 0/1] sched: fix typo in sched-rt-group.txt file
In-Reply-To: <49b7c2350905192150n4d6b710er571b8a1bd228198b@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0905201433060.1080@gandalf.stny.rr.com>
References: <1242783552.31161.53.camel@centos51> <49b7c2350905192150n4d6b710er571b8a1bd228198b@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-493579174-1242845302=:1080"
Content-ID: <alpine.DEB.2.00.0905201451440.1080@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-493579174-1242845302=:1080
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <alpine.DEB.2.00.0905201451441.1080@gandalf.stny.rr.com>


On Wed, 20 May 2009, GeunSik Lim wrote:

> 2009/5/20 GeunSik Lim <leemgs1@gmail.com>:
> >
> >
> > Dear Ingo,
> >
> >
> > I made 2 patch files again about static prioriy levels according to ing=
o's advice
> > and explanation. (Reference: http://marc.info/?t=3D124211992800003&r=3D=
1&w=3D2 archives. )
> >
> > Fix static priority related range and chart map(userspace/kernelspace) =
of ftrace.
> > =A0 - about chart map of static priority in =A0ftrace.txt file
> > =A0 - about static priority levels(range) in sched-rt-group.txt file
> >
> >
> > commit d6af702008117ca489a2f5476239d1688a517e98
> > Author: GeunSik,Lim <leemgs1@gmail.com>
> > Date: =A0 Tue May 12 17:20:32 2009 +0900
> >
> > =A0 =A0sched: fix typo in sched-rt-group.txt file
> >
> > =A0 =A0Fix typo about static priority's range.
> >
> > =A0 =A0* Kernel Space priority 0(high) to 99(low) =A0 --> User Space RT=
 priority 99(high) to 1(low)
> > =A0 =A0* Kernel Space priority 100(high) to 139(low)--> User Space nice=
 -20(high) to 19(low)
> >
>=20
> Ingo,
> I want to  change some descriptions according to below discussion.
>=20
> before) * Kernel Space priority 0(high) to 99(low)   --> User Space RT
> priority 99(high) to 1(low)
> after)    *  Kernel Space priority 0(high) to 98(low)   --> User Space
> RT priority 99(high) to 1(low)
>=20
> I want to your advice and opinion about this changes.
>=20
> If I mistook, Please correct me.
>=20
> thks.
>=20
>=20
>=20
> Steven Rostedt:
>   Shouldn't that be:
>   Kernel priority: 0(high) to 98(low)    =3D=3D> user RT priority 99(high=
) to 1(low)
>=20
> GeunSik Lim :
>   Thank you for your opinion.  I think about corrected expression for
>   quick chart to map between kernel space and user space in ftrace .
>=20
> Steven Rostedt:
>  100 items does not map to 99. Which begs the question, what can have
>  internal kernel priority 99?
>=20
> GeunSik Lim :
>   ok.  Below example is about  kernel (static) priority 99 that you said.
>   please, refer
>   to http://www.kernel.org/doc/man-pages/online/pages/man2/sched_setsched=
uler.2.html
>  webpage.
>=20
>   For processes scheduled under one of the normal scheduling policies
>   (SCHED_OTHER, SCHED_IDLE, SCHED_BATCH), sched_priority is not used in
>   scheduling decisions (it must be specified as 0).
>=20
> int main (int argc, char **argv)
> {=09int pidnumber, ret;
> =09struct sched_param p;
> =09p.sched_priority =3D 0; <------ Kernel (static) priority.
> =09if (argc !=3D 2) {
> =09=09printf("usage: setbatch <pid>\n");
> =09=09exit(-1);
> =09}
> =09pidnumber =3D atol(argv[1]);
>          /* 3 =3D Number of SCHED_BATCH Constant */
> =09ret =3D sched_setscheduler(pidnumber, 3, &p);
> =09if (ret) {
> =09=09printf("could not set pid %d to SCHED_BATCH: err %d.\n", pid, ret);
> =09=09return -1;
> =09}
> =09printf("pid %d is SCHED_BATCH from now on.\n", pid);
> =09return 0;
> }
>=20
>=20
> >
> > =A0 =A0Processes scheduled with SCHED_OTHER or SCHED_BATCH must be assi=
gned
> > =A0 =A0the static priority 0. Processes scheduled under SCHED_FIFO or S=
CHED_RR
> > =A0 =A0can have a static priority in the range 1 to 99.
> > =A0 =A0(reference: $> man 2 sched_setscheduler)
> >
> > =A0 =A0Signed-off-by: GeunSik Lim <geunsik.lim@samsung.com>
> >
> > diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation=
/scheduler/sched-rt-group.txt
> > index 5ba4d3f..1537146 100644
> > --- a/Documentation/scheduler/sched-rt-group.txt
> > +++ b/Documentation/scheduler/sched-rt-group.txt
> > @@ -169,7 +169,7 @@ get their allocated time.
> >
> > =A0Implementing SCHED_EDF might take a while to complete. Priority Inhe=
ritance is
> > =A0the biggest challenge as the current linux PI infrastructure is gear=
ed towards
> > -the limited static priority levels 0-139. With deadline scheduling you=
 need to
> > +the limited static priority levels 0-99. With deadline scheduling you =
need to
> > =A0do deadline inheritance (since priority is inversely proportional to=
 the
> > =A0deadline delta (deadline - now).

Note, this document deals with internal kernel manipulations. The "prio"=20
inside the kernel is indeed 0-139. Actually, if we count the idle task, it=
=20
is 0-140. The PI code will also deal with non RT tasks so it is correct to=
=20
say that the priority inheritance deals with 0-139 (I don't think the idle=
=20
task ever touches anything needing PI).

The sched_setscheduler user API uses a different priority mapping. I was=20
looking at the code inside sched.c and I believe this is the mapping:


0 to 98 - maps to RT tasks 99 to 1 (SCHED_RR or SCHED_FIFO)

99 - maps to internal kernel threads that want to be lower than RT tasks=20
     but higher than SCHED_OTHER tasks. Although I'm not sure if any=20
     kernel thread actually uses this. I'm not even sure how this can be
     set, because the internal sched_setscheduler function does not allow
     for it.

100 to 139 - maps nice levels -20 to 19. These are not set via=20
    sched_setscheduler, but are set via the nice system call.

140 - reserved for idle tasks.

-- Steve

--8323328-493579174-1242845302=:1080--
