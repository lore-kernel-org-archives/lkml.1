Return-Path: <linux-kernel-owner+w=401wt.eu-S1760540AbZC0TVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760540AbZC0TVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 15:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZC0TVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 15:21:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54684 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbZC0TVN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 15:21:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 5/13] score - New architecure port to SunplusCT S+CORE processor
Date: Fri, 27 Mar 2009 20:19:53 +0100
User-Agent: KMail/1.9.9
Cc: liqin.chen@sunplusct.com, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <OFE9A5E3A2.37B73BA8-ON48257586.0008CFAC-48257586.00091B05@sunplusct.com> <20090327184013.GB21149@uranus.ravnborg.org>
In-Reply-To: <20090327184013.GB21149@uranus.ravnborg.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903272019.53689.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/XEyu0HMbdKRoLhhnqkN8gcsN8T1L8P4V2DxX
 xdjFfmAw3zVbqIBMrJct/gksDJfJ8XpOQYT3PjffSZREJSk/BB
 PfcJLH0P7X3ZH1HhuPOOg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009, Sam Ravnborg wrote:
> > +struct shmid64_ds {
> > +       struct ipc64_perm       shm_perm;       /* operation perms */
> > +       size_t                  shm_segsz;      /* size of segment (bytes) 
> > */
> > +       __kernel_time_t         shm_atime;      /* last attach time */
> > +       __kernel_time_t         shm_dtime;      /* last detach time */
> > +       __kernel_time_t         shm_ctime;      /* last change time */
> > +       __kernel_pid_t          shm_cpid;       /* pid of creator */
> > +       __kernel_pid_t          shm_lpid;       /* pid of last operator */
> > +       unsigned long           shm_nattch;     /* no. of current attaches 
> > */
> > +       unsigned long           __unused1;
> > +       unsigned long           __unused2;
> > +};
> 
> This is an exported header and you mix wide specific and generic types.
> The recommended way is to stick to the __[u]{32,64}int versions + the kernel
> specific types as __kernel_pid_t.
> In other words avoid use of int, long etc in your exported headers.
> 

This is correct in general, but in this particular case (SysV IPC) it is
exactly what most of the other architectures do. It's basically impossible
to get this right, so simply doing the same as x86 is the best option
I found (unlike most of the other headers).

	Arnd <><
