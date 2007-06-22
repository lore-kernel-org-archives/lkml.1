Return-Path: <linux-kernel-owner+w=401wt.eu-S1760882AbXFVSf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882AbXFVSf3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760078AbXFVSfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:35:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:34435 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760018AbXFVSfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:35:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sIn9P7bZQmc01u8Tyy8iZhCd7HT9gIfeo+jf0tFKsV4kdY1K2Ylc7EKMeV/zKVeTI0H2wHS+apd/LuJV2eBnr3qgouo6qIsoQVk5eYXFn2oGmMxfphKzAbTuJBwGhvvE9Y+ahefNa4wzU9UWE6mtSSCaDJsObzOOkbO4rmm4CfA=
Message-ID: <a781481a0706221135q6972e1f8u649356ab7932715d@mail.gmail.com>
Date: Sat, 23 Jun 2007 00:05:11 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "David Teigland" <teigland@redhat.com>
Subject: Re: [patch] DLM: fix kconfig dependency
Cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <20070622180500.GD6381@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070622140615.GP5193@alberich.amd.com>
	 <20070622180500.GD6381@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/22/07, David Teigland <teigland@redhat.com> wrote:
> On Fri, Jun 22, 2007 at 04:06:15PM +0200, Andreas Herrmann wrote:
> > Avoid kernel build error (as DLM depends on SYSFS)
> >
> >   LD      vmlinux
> >   fs/built-in.o: In function `dlm_lockspace_init':
> >   : undefined reference to `kernel_subsys'
> >   fs/built-in.o: In function `configfs_init':
> >   mount.c:(.init.text+0xef4): undefined reference to `kernel_subsys'
> >
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> >
> > diff --git a/fs/dlm/Kconfig b/fs/dlm/Kconfig
> > index 69a9469..c0e4c59 100644
> > --- a/fs/dlm/Kconfig
> > +++ b/fs/dlm/Kconfig
> > @@ -1,5 +1,5 @@
> >  menu "Distributed Lock Manager"
> > -     depends on EXPERIMENTAL && INET
> > +     depends on EXPERIMENTAL && INET && SYSFS
> >
> >  config DLM
> >       tristate "Distributed Lock Manager (DLM)"
>
> There's a been a lot of back and forth on this from a number of different
> people:
>
> 1/18/06   depends on SYSFS
> 4/25/06 - depends on SYSFS
> 2/05/07 + select SYSFS
> 2/05/07 - select SYSFS
>         + depends on SYSFS
> 5/01/07 - depends on SYSFS
>
> It looks like the last removal was in error and it should be added back.

DLM needs to depend on SYSFS for another reason: it directly
"select"s CONFIGFS_FS when configfs itself "depends on SYSFS".
I suspect it selects configfs directly to make it easier to pick DLM,
by not forcing users to first go and pick configfs just to make DLM
visible in menuconfig, but such usage of select is generally "evil".

There was a thread started by Al Viro some time back which
started discussions on possible kbuild-solutions to this "select
of a symbol that itself depends on another" problem, but I'm not
sure what happened of that ...

Satyam
