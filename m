Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbYHSPMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbYHSPMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 11:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYHSPMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 11:12:08 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:23745 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbYHSPMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references:x-google-sender-auth;
        b=OTSiMnf5NspbmTdI35e2PCgfV96K3tXrHto6+iWh83CNEnmOd2C9ORLs+tlzNWsBpA
         MsEkkgNVoLNxwFyapqy/zEK7SAorlN96kQrt0xLFWrPCHmQ9KFAWQxCH9jrM9qw5gA3q
         qy93TzNPLcd5j4ofZwSOmmT7HWQo0r1TFJfj0=
Message-ID: <a2776ec50808190812g15ecd48dw23db4337016f38a2@mail.gmail.com>
Date: Tue, 19 Aug 2008 17:12:04 +0200
From: righi.andrea@gmail.com
Reply-To: righiandr@users.sourceforge.net
To: "Paul Menage" <menage@google.com>
Subject: Re: [RFC] [PATCH -mm] cgroup: uid-based rules to add processes efficiently in the right cgroup
Cc: "Vivek Goyal" <vgoyal@redhat.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Kazunaga Ikeno" <k-ikeno@ak.jp.nec.com>,
       "Morton Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Graf" <tgraf@redhat.com>, "Ulrich Drepper" <drepper@redhat.com>
In-Reply-To: <6599ad830808181405i3ec1f9fdp4d8ca7ab675b2c5f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701191126.GA17376@redhat.com>
	 <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com>
	 <20080710104852.797fe79c@cuia.bos.redhat.com>
	 <20080710154035.GA12043@redhat.com>
	 <20080711095501.cefff6df.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080714135719.GE16673@redhat.com> <487B665B.9080205@sun.com>
	 <20080714152142.GJ16673@redhat.com> <48A7FE7B.3060309@gmail.com>
	 <6599ad830808181405i3ec1f9fdp4d8ca7ab675b2c5f@mail.gmail.com>
X-Google-Sender-Auth: 62e46957820f987e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/08, Paul Menage <menage@google.com> wrote:
> On Sun, Aug 17, 2008 at 3:33 AM, Andrea Righi <righi.andrea@gmail.com>
> wrote:
>>
>> [ I wrote this patch for a "special purpose" environment, where a lot of
>> short-lived processes belonging to different users are spawned by
>> different daemons,
>
> What kinds of daemons are these? Is it not possible to add some
> libcgroup calls to these daemons?

unfortunately I don't have too much details for now, so I was just
looking for the most generic solution. The PAM lib approach seems
reasonable for each daemon that represents an entry point to the
system, and, to a large degree, I like the userspace solution (e.g.
the libcgroup as reported by Vivek). It seems to be the right way to
handle all the possible/complex rule an admin would like to define.

>
> I'm reluctant to add features like this to the kernel side of cgroups

agree

> due to their "magical" nature - any task that does a setuid() now
> risks being swept off into a different cgroup.

If the admin configures so, moving tasks that do setuid() in different
cgroups should be an expected behaviour, isn't it?

>
> Having the cgroup attachment done explicitly e.g. by a PAM library at
> login time is much less likely to cause unexpected behaviour.
>
> Maybe if we had a way to control which tasks the magical setuid
> switching occurs for, it might be more acceptable. (Perhaps base it on
> the cgroup of the task that's doing the setuid as well?

do you mean create a cgroup subsystem to handle different per-cgroup
setuid() switching behaviours?

>
> Other thoughts:
>
> - what about other uids (euid, fsuid)?
>
> - what about multiple hierarchies?
>
> - if the attach fails, userspace gets no notification.

good points.

For the last one we could just return an error code from cgroup_fork()
and  goto bad_fork_cleanup_cgroup (in this way the fork/exec would
fail anyway).

>
> Paul
>

Thanks,
-Andrea
