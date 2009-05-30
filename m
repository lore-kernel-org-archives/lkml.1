Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbZE3NhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbZE3NhA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 09:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758744AbZE3Ngw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 09:36:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42355 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527AbZE3Ngw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 09:36:52 -0400
Date: Sat, 30 May 2009 09:36:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: GeunSik Lim <leemgs1@gmail.com>
cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       trivial@kernel.org, balagi@justmail.de, bgamari@gmail.com,
       Ingo Molnar <mingo@elte.hu>, inaky.perez-gonzalez@intel.com
Subject: Re: [RFC V2 PATCH]debugfs:Fix terminology inconsistency of dir name
  to mount debugfs filesystem.
In-Reply-To: <49b7c2350905300238k5f6259fne30ad94f8fbf7e20@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0905300935570.14994@gandalf.stny.rr.com>
References: <1243315163.14685.17.camel@centos51>  <1243613134.20635.14.camel@centos51>  <alpine.DEB.2.00.0905291240150.31247@gandalf.stny.rr.com>  <49b7c2350905291843i402b7161xf05fdb87eb77f73f@mail.gmail.com>  <alpine.DEB.2.00.0905292204280.14994@gandalf.stny.rr.com>
 <49b7c2350905300238k5f6259fne30ad94f8fbf7e20@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-857149259-1243690611=:14994"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-857149259-1243690611=:14994
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE


On Sat, 30 May 2009, GeunSik Lim wrote:
> > Here's the function I use:
> >
> > #define _STR(x) x
> > #define STR(x) _STR(x)
> > #define MAX_PATH 256
> >
> > const char *find_debugfs(void)
> > {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0static char debugfs[MAX_PATH+1];
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0static int debugfs_found;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char type[100];
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0FILE *fp;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (debugfs_found)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return debugfs;
> >
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((fp =3D fopen("/proc/mounts","r")) =3D=
=3D NULL) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0perror("/proc/mo=
unts");
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0while (fscanf(fp, "%*s %"
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0STR(MAX_PATH)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0"s %99s %*s %*d %*d\n",
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0debugfs, type) =3D=3D 2) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (strcmp(type,=
 "debugfs") =3D=3D 0)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0break;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0fclose(fp);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (strcmp(type, "debugfs") !=3D 0) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr, =
"debugfs not mounted");
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return NULL;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0debugfs_found =3D 1;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return debugfs;
> > }
> >
> > This might be a good idea to show it. This is the most robust since it
> > does not hard code the debugfs directory.
> Yes, I think so. I have one opinion in the above find_debugfs() function.
> Default directory  is "/sys/kernel/debug/tracing" in ftrace.txt file
> as you mentioned.
> I will append  below code for "***/tracing/" directory name.
>=20
>          int size;
>          [...]
>          size =3D MAX_PATH - strlen(debugfs);
>          strncat(debugfs, "/tracing/", size);
>          return debugfs;

Heh, I usually have another function to add the /tracing part. But sure,=20
we could do that too.

-- Steve

--8323328-857149259-1243690611=:14994--
