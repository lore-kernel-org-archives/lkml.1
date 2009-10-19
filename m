Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbZJSO5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbZJSO5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756325AbZJSO5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:57:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:47170 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237AbZJSO5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:57:11 -0400
Date: Mon, 19 Oct 2009 16:57:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 2/7] ipc: fix trivial warning
In-Reply-To: <94a0d4530910190750j5674ef13m93198b68d305b188@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.0910191655220.8582@wotan.suse.de>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>  <1255906474-25091-3-git-send-email-felipe.contreras@gmail.com>  <alpine.LSU.2.00.0910191610160.8582@wotan.suse.de> <94a0d4530910190750j5674ef13m93198b68d305b188@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-391807210-1255964234=:8582"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-391807210-1255964234=:8582
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Mon, 19 Oct 2009, Felipe Contreras wrote:

> >> ipc/msg.c: In function ?msgctl_down?:
> >> ipc/msg.c:415: warning: ?msqid64? may be used uninitialized in this function
> >>
> >> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> >> ---
> >>  ipc/msg.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/ipc/msg.c b/ipc/msg.c
> >> index 2ceab7f..085bd58 100644
> >> --- a/ipc/msg.c
> >> +++ b/ipc/msg.c
> >> @@ -412,7 +412,7 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
> >>                      struct msqid_ds __user *buf, int version)
> >>  {
> >>       struct kern_ipc_perm *ipcp;
> >> -     struct msqid64_ds msqid64;
> >> +     struct msqid64_ds uninitialized_var(msqid64);
> >>       struct msg_queue *msq;
> >>       int err;
> >
> > What gcc are you using? I am not getting any warning at least with gcc
> > "(SUSE Linux) 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision
> > 135036]"
> 
> gcc (GCC) 4.4.1 20090725 (Red Hat 4.4.1-2)
> 
> Since I moved to Fedora 11 I get more warnings than other people,
> possibly because gcc 4.4.

Wouldn't it be better just to report this to gcc developers as a bug 
instead?

I have verified both with 4.1 and 4.3, and it doesn't emit this 
false-positive warning, so there have been gcc versions getting this 
right. Ergo gcc developers should rather fix this "regression" and revert 
to the old behavior, methinks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
--168427776-391807210-1255964234=:8582--
