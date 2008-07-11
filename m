Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbYGKLxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbYGKLxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbYGKLxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:53:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbYGKLxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:53:06 -0400
Subject: Re: [PATCH 17/18] [GFS2] Remove support for unused and pointless
	flag
From: Steven Whitehouse <swhiteho@redhat.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
In-Reply-To: <Pine.LNX.4.61.0807110714110.18083@chaos.analogic.com>
References: <121577107950-git-send-email-swhiteho@redhat.com>
	 <12157710872782-git-send-email-swhiteho@redhat.com>
	 <1215771089769-git-send-email-swhiteho@redhat.com>
	 <1215771091790-git-send-email-swhiteho@redhat.com>
	 <12157710931623-git-send-email-swhiteho@redhat.com>
	 <12157710954145-git-send-email-swhiteho@redhat.com>
	 <12157710973601-git-send-email-swhiteho@redhat.com>
	 <12157710983282-git-send-email-swhiteho@redhat.com>
	 <12157711013356-git-send-email-swhiteho@redhat.com>
	 <12157711023743-git-send-email-swhiteho@redhat.com>
	 <12157711041157-git-send-email-swhiteho@redhat.com>
	 <1215771106247-git-send-email-swhiteho@redhat.com>
	 <12157711073280-git-send-email-swhiteho@redhat.com>
	 <12157711093284-git-send-email-swhiteho@redhat.com>
	 <12157711133727-git-send-email-swhiteho@redhat.com>
	 <12157711153366-git-send-email-swhiteho@redhat.com>
	 <12157711171692-git-send-email-swhiteho@redhat.com>
	 <1215771119431-git-send-email-swhiteho@redhat.com>
	 <Pine.LNX.4.61.0807110714110.18083@chaos.analogic.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Fri, 11 Jul 2008 12:52:19 +0100
Message-Id: <1215777139.4011.188.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2008-07-11 at 07:19 -0400, linux-os (Dick Johnson) wrote:
> On Fri, 11 Jul 2008 swhiteho@redhat.com wrote:
> 
> > From: Steven Whitehouse <swhiteho@redhat.com>
> >
> > The ability to mark files for direct i/o access when opened
> > normally is both unused and pointless, so this patch removes
> > support for that feature.
> [Snipped...]
> 
> So linux is no longer going to support commercial databases?
> Oracle and others need the O_DIRECT attribute. Linux can
> probably igonore it, but such an open cannot fail or else
> Linux gets thrown out of the commercial enterprise when
> an upgrade disables an entire financial institution.
> 
> Cheers,
> Dick Johnson
> Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
> My book : http://www.AbominableFirebug.com/
> _
> 
No, thats not what it means...., but perhaps I could have explained it
better. You can still use O_DIRECT flags in open syscalls in exactly the
same way as before. What this patch removes is the (never used, and IMHO
pointless) feature of being able to set a flag on the inode (via
chattr/setattr) to force open's to set O_DIRECT in every case, even when
the application didn't ask for it. The reason that its pointless is that
applications which don't otherwise support O_DIRECT are very unlikely to
supply suitably aligned buffers and I/O requests, so that overriding the
O_DIRECT flag for such applications will most likely result in an I/O
error.

GFS2 will still support O_DIRECT just the same as it has always done,
and this doesn't affect any other filesystem's support for that feature
either,

Steve.


