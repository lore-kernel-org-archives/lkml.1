Return-Path: <linux-kernel-owner+w=401wt.eu-S937169AbXG3Aze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937169AbXG3Aze (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 20:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764828AbXG3Az1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 20:55:27 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:4206 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763885AbXG3Az0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 20:55:26 -0400
Date: Sun, 29 Jul 2007 20:54:10 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eugene Teo <eteo@redhat.com>
Cc: Martin Pitt <martin.pitt@ubuntu.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jeremy@goop.org, wwoods@redhat.com
Subject: Re: [PATCH 0/3] core_pattern: cleaned up repost/continuing post of core_pattern enhancements
Message-ID: <20070730005410.GA11490@hmsreliant.homelinux.net>
References: <20070727200050.GA18946@hmsreliant.homelinux.net> <46AC6EAB.7000502@redhat.com> <20070729121444.GA9644@hmsreliant.homelinux.net> <46AC900E.9090405@redhat.com> <20070729155300.GC5794@piware.de> <46AD26A3.4090606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AD26A3.4090606@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 07:45:39AM +0800, Eugene Teo wrote:
> Hi Martin,
> 
> Martin Pitt wrote:
> > Eugene Teo [2007-07-29 21:03 +0800]:
> >>>> Also, it is probably good to think how we can "drop privileges" while piping
> >>>> the core dump output to an external program. A malicious user can potentially
> >>>> use it as a possible backdoor since anything that is executed by "|program" will
> >>>> be executed with root privileges.
> >>>>
> >>> It was my understanding that apport already did this.
> >> I haven't looked at apport yet, but are you talking about the userspace portion of
> >> apport or the kernel changes in the Ubuntu kernel?
> > 
> > Similarly to Neil's patches, the Ubuntu kernel calls the userspace
> > helper as root, too. Apport drops privileges to the target process as
> > soon as possible (there are a few things it needs to do before, like
> > opening an fd to the crash file in /var/crash/ if that is only
> > writeable by root).
> 
> Just sharing some thoughts. Wouldn't it be more logical to drop the privileges first,
> then call the userspace helper program? I know that this will limit tools like apport
> to be able to read and/or write files that are only writable by root, but there ought
> to be a better way to do this? What if the program piped is not a legitimate program?
> 
We could do that I suppose, but /proc/<pid of crashing process>/* contains
informatino apport (and other apps need) to help diagnose problems during a
crash.  To provide that information, we would then need to build out
infrastructure to pipe that information in-band through the pipe (perhaps
through ELF notes).  Doable yes, but certainly not a small patch (consider
piping all of the files in /proc/<pid> as ELF notes).

Regarding security, and the use of non-legit programs: If the program pointed to
by core pattern does not exist, then the exec simply fails, and the core is
lost.  Beyond that, core_pattern is only writable by root, and its teh sysadmins
responsibility to ensure that it points to valid and secured program.

> Also, maybe it is good to make this portion of the code optional too, so that if no
> one is using this "ispipe" feature, we just turn it off.
> 
you mean like a build time config option? I'm not sure I see lots of value,
although, it seems like it would straightforward enough to do if you feel
strongly about it.

Regards
Neil

> Eugene

-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
