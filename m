Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYHRVF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYHRVF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYHRVFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:05:50 -0400
Received: from smtp-out.google.com ([216.239.33.17]:41735 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbYHRVFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:05:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=TA/ZQo2ygNo+LFvPqxL3TVxyfabCyrEEocmsdaahmYwg7TAKrrrBnrLQWFol9GyHS
	VotEWG5gxP9aZ0+XhunbA==
Message-ID: <6599ad830808181405i3ec1f9fdp4d8ca7ab675b2c5f@mail.gmail.com>
Date: Mon, 18 Aug 2008 14:05:36 -0700
From: "Paul Menage" <menage@google.com>
To: righi.andrea@gmail.com
Subject: Re: [RFC] [PATCH -mm] cgroup: uid-based rules to add processes efficiently in the right cgroup
Cc: "Vivek Goyal" <vgoyal@redhat.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Kazunaga Ikeno" <k-ikeno@ak.jp.nec.com>,
       "Morton Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Graf" <tgraf@redhat.com>, "Ulrich Drepper" <drepper@redhat.com>
In-Reply-To: <48A7FE7B.3060309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080701191126.GA17376@redhat.com>
	 <20080703155446.GB9275@redhat.com>
	 <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com>
	 <20080710104852.797fe79c@cuia.bos.redhat.com>
	 <20080710154035.GA12043@redhat.com>
	 <20080711095501.cefff6df.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080714135719.GE16673@redhat.com> <487B665B.9080205@sun.com>
	 <20080714152142.GJ16673@redhat.com> <48A7FE7B.3060309@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 3:33 AM, Andrea Righi <righi.andrea@gmail.com> wrote:
>
> [ I wrote this patch for a "special purpose" environment, where a lot of
> short-lived processes belonging to different users are spawned by
> different daemons,

What kinds of daemons are these? Is it not possible to add some
libcgroup calls to these daemons?

I'm reluctant to add features like this to the kernel side of cgroups
due to their "magical" nature - any task that does a setuid() now
risks being swept off into a different cgroup.

Having the cgroup attachment done explicitly e.g. by a PAM library at
login time is much less likely to cause unexpected behaviour.

Maybe if we had a way to control which tasks the magical setuid
switching occurs for, it might be more acceptable. (Perhaps base it on
the cgroup of the task that's doing the setuid as well?

Other thoughts:

- what about other uids (euid, fsuid)?

- what about multiple hierarchies?

- if the attach fails, userspace gets no notification.

Paul
