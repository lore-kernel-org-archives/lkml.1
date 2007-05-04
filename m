Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbXEDDsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbXEDDsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 23:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbXEDDsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 23:48:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:17684 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbXEDDsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 23:48:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=j4mHM4yahgrG+eci/+wBTkWPBKT0QaHpx9qwRIB0jIjtC0VD2whw1t8o7sQnxOPUqEW1DXB0T0rXdiX795iGhmG6DJm55QRvSiszvHMYMmSomCL5R60fia2WVr7792oC8JixuEGj7rQvlg7CEUwRCqY0NCY/QjUqLh57o58Eltk=
Message-ID: <d20c3b7d0705032048l8c10d11i98a13881b1c8b3f3@mail.gmail.com>
Date: Fri, 4 May 2007 05:48:18 +0200
From: "=?ISO-8859-1?Q?=D8yvind_V=E5gen_J=E6gtnes?=" <lorrides@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: Routing 600+ vlan's via linux problems (looks like arp problems)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070503222334.GD943@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <d20c3b7d0705031325r13834382r38ea31f26965c50@mail.gmail.com>
	 <20070503205341.GB943@1wt.eu>
	 <Pine.LNX.4.61.0705032255080.18504@yvahk01.tjqt.qr>
	 <d20c3b7d0705031412y11f18288t321c097aaad4b38b@mail.gmail.com>
	 <20070503222334.GD943@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again :)

On 5/4/07, Willy Tarreau <w@1wt.eu> wrote:
> On Thu, May 03, 2007 at 11:12:09PM +0200, Øyvind Vågen Jægtnes wrote:
> > On 5/3/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> > >
> > >On May 3 2007 22:53, Willy Tarreau wrote:
> > >>> For the rest all we see in the arp cache is (incomplete)
> > >>
> > >>I suspect that your arp cache is full (128 entries by default).
> > >>Check /proc/sys/net/ipv4/neigh/gc_thresh1 (128 for me). You can
> > >>set it as high as gc_thresh2 (512 for me), and I don't know what
> > >>happens above.
> > >
> > >Above, you will perhaps need the not-so-elegant userspace arpd :-/
> >
> > Yes, i was suspecting that the arp cache got full, but i will try
> > increasing it :)
> > Would there be any huge bugs if i change these lines in arp.c:
> >
> >        .gc_thresh1 =   128,
> >        .gc_thresh2 =   512,
> >
> > to
> >
> >        .gc_thresh1 =   700,
> >        .gc_thresh2 =   700,
> >
> > under the definition for struct arp_tbl?
>
> I don't think it could cause a problem, but network people will surely
> correct me if I'm wrong.

System is up and running perfectly now, it is routing everything at
about 200 mbps now with only 5% load avg with the above changes to
arp.c

So the real question now is, why is this number so low by default?
It would probably be much better if this could be handled dynamically
in the kernel.

> > This setup will only run for about 1-2 hours while we fix the hardware
> > router (it is running now, but only on a backup flash card solution.
> > the harddrive in it died ;)
>
> Huhhh! Please tell us exactly what make and model of ROUTER you are using
> which embeds a HARD DRIVE, so that we recall never to buy that ! Having
> seen uptimes of 5 years on moderately big access routers, I would have
> find it awful to see them die multiple times in that timeframe because
> of a crappy IDE drive inside !

Its a Juniper M7i
It comes default with a 5400 rpm laptop 2.5" harddrive but now we
bought a more robust "server" 2.5" harddrive. It still barfs on the OS
install, so the linux is doing all the job now. Will get a juniper guy
to come and fix :)

As a side note, i'm starting to wonder if it was worth the $20k when i
could just have a linux machine to do the job with a clone for backup
;)

regards
Øyvind Vågen Jægtnes
+47 96 22 03 08
lorrides@gmail.com
