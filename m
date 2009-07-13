Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbZGMPpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbZGMPpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756241AbZGMPpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:45:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:48283 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194AbZGMPpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:45:04 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH] taskstats: Fix CGROUPSTATS_TYPE_CGROUP_STATS having same value as TASKSTATS_TYPE_PID
Date: Mon, 13 Jul 2009 21:16:43 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
References: <200907131831.12994.knikanth@suse.de> <20090713134158.GD5051@balbir.in.ibm.com>
In-Reply-To: <20090713134158.GD5051@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907132116.43647.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 July 2009 19:11:58 Balbir Singh wrote:
> * Nikanth Karthikesan <knikanth@suse.de> [2009-07-13 18:31:12]:
> > Hi
> >
> > Currently we never get message from kernel to userspace of type
> > TASKSTATS_TYPE_PID. Otherwise this could have been spotted earlier.
> >
> > I was trying to add a new taskstat command that would return response of
> > type TASKSTATS_TYPE_PID.
> >
> > Having the same values would restrict one not to use the same netlink
> > socket for a command that would return response of type
> > TASKSTATS_TYPE_PID and the CGROUPSTATS_CMD_GET command.
> >
> > Should we fix it by using values after __TASKSTATS_TYPE_MAX.
> >
> > Changing this now might break pre-built binaries. Or is this intended,
> > and the application is not supposed to use CGROUPSTATS and TASKSTATS on
> > the same socket?
>
> Ideally they are supposed to be on different sockets, but nothing
> really is hard and fast in terms of rules.
>
> > Thanks
> > Nikanth
> >
> > Currently we never get message from kernel to userspace of type
> > TASKSTATS_TYPE_PID. Otherwise this could have been spotted earlier.
> > Having the values in the same range would restrict one not to use the
> > same netlink socket for a command that would return response of type
> > TASKSTATS_TYPE_PID and the CGROUPSTATS_CMD_GET command. Fix it by using
> > values after
> > __TASKSTATS_TYPE_MAX.
> >
> > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> >
> > ---
> >
> >
> > diff --git a/include/linux/cgroupstats.h b/include/linux/cgroupstats.h
> > index 3753c33..87b31f0 100644
> > --- a/include/linux/cgroupstats.h
> > +++ b/include/linux/cgroupstats.h
> > @@ -53,7 +53,7 @@ enum {
> >  #define CGROUPSTATS_CMD_MAX (__CGROUPSTATS_CMD_MAX - 1)
> >
> >  enum {
> > -	CGROUPSTATS_TYPE_UNSPEC = 0,	/* Reserved */
> > +	CGROUPSTATS_TYPE_UNSPEC = __TASKSTATS_TYPE_MAX,	/* Reserved */
> >  	CGROUPSTATS_TYPE_CGROUP_STATS,	/* contains name + stats */
> >  	__CGROUPSTATS_TYPE_MAX,
> >  };
>

Also this would unnecessarily increase the value of __CGROUPSTATS_TYPE_MAX. 
So, please dont take this patch. :) I would send a better fix, soon.

Thanks
Nikanth
