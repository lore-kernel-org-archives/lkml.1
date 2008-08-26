Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbYHZAy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbYHZAy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 20:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYHZAys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 20:54:48 -0400
Received: from smtp-out.google.com ([216.239.33.17]:19584 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbYHZAyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 20:54:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=gXVKsLqLF4DDtoTVIFltxNsM2r+12SChEvnijPjelGFXqKqdqUmxMHtRiC4eTwCtA
	kcCWbVFWxqcZ4zVyaU4WA==
Message-ID: <6599ad830808251754l146588dax65aeff2cc22ac0c1@mail.gmail.com>
Date: Mon, 25 Aug 2008 17:54:39 -0700
From: "Paul Menage" <menage@google.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Subject: Re: [RFC] [PATCH -mm] cgroup: uid-based rules to add processes efficiently in the right cgroup
Cc: righi.andrea@gmail.com,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Kazunaga Ikeno" <k-ikeno@ak.jp.nec.com>,
       "Morton Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Graf" <tgraf@redhat.com>, "Ulrich Drepper" <drepper@redhat.com>
In-Reply-To: <20080819125710.GA18972@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080703155446.GB9275@redhat.com>
	 <20080710104852.797fe79c@cuia.bos.redhat.com>
	 <20080710154035.GA12043@redhat.com>
	 <20080711095501.cefff6df.kamezawa.hiroyu@jp.fujitsu.com>
	 <20080714135719.GE16673@redhat.com> <487B665B.9080205@sun.com>
	 <20080714152142.GJ16673@redhat.com> <48A7FE7B.3060309@gmail.com>
	 <6599ad830808181405i3ec1f9fdp4d8ca7ab675b2c5f@mail.gmail.com>
	 <20080819125710.GA18972@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 5:57 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Same thing will happen if we implement the daemon in user space. A task
> who does seteuid(), can be swept away to a different cgroup based on
> rules specified in /etc/cgrules.conf.

Yes, I'm not so keen on a daemon magically pulling things into a
cgroup based on uid either, for the same reasons.

But a user-space based solution can be much more flexible (e.g. easier
to configure it to only move tasks from certain source cgroups).

>
> What do you mean by risk? This is the policy set up by system admin and
> behaviour would seem consistent as per the policy. If an admin decides
> that tasks of user "apache" should run into /container/cpu/apache cgroup and
> if a "root" tasks does seteuid(apache), then it manes sense to move task
> to /container/cpu/apache.

The kind of unexpected behaviour I was imagining was when some other
daemon (e.g. ftpd?) unexpectedly does a setuid to one of the
magically-controlled users, and results in that daemon being pulled
into the specified cgroup. For something like cpu maybe that's mostly
benign (but what moves it back into its original group after it
switches back to root?) but for other subsystems it could be more
painful (memory, device access, etc).

>
> Exactly what kind of scenario do you have in mind when you want the policy
> to be enforced selectively based on task (tid)?

I was thinking of something like possibly a per-cgroup file (that also
affected child cgroups) rather than a global file. That would also
automatically handle multiple hierarchies.

Paul
