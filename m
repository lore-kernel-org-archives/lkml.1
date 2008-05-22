Return-Path: <linux-kernel-owner+w=401wt.eu-S934817AbYEVIh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934817AbYEVIh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760234AbYEVIhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:37:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759708AbYEVIho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:37:44 -0400
Date: Thu, 22 May 2008 01:36:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Paul Menage" <menage@google.com>
Cc: "Cedric Le Goater" <clg@fr.ibm.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.osdl.org>, stable@kernel.org
Subject: Re: [PATCH -mm] remove node_ prefix_from ns subsystem
Message-Id: <20080522013612.cb196653.akpm@linux-foundation.org>
In-Reply-To: <6599ad830805220123t7a3848eeg244393723d5fd08d@mail.gmail.com>
References: <48344409.9090903@fr.ibm.com>
	<20080521220657.12e8e8c9.akpm@linux-foundation.org>
	<6599ad830805220011u77313ed7s2c0c9d4a658133cc@mail.gmail.com>
	<20080522003213.d677ba30.akpm@linux-foundation.org>
	<48352277.4010703@fr.ibm.com>
	<20080522011053.680f7f65.akpm@linux-foundation.org>
	<6599ad830805220123t7a3848eeg244393723d5fd08d@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 01:23:35 -0700 "Paul Menage" <menage@google.com> wrote:

> Hi Andrew,
> 
> On Thu, May 22, 2008 at 1:10 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > What the change is, why it is being made, what the user-visible
> > presentation is, what the impact upon users is, why we think it won't
> > be a problem, etc?  The stuff which should have been right there from
> > day one, before the code change was even made?
> 
> The change is that previously when cgroup_clone() was called
> (currently only from the unshare path in ns_proxy cgroup, you'd get a
> new group named "node_$pid" whereas now you'll get a group named after
> just your pid.)
> 
> The only users who would notice it are those who are using the
> ns_proxy cgroup subsystem to auto-create cgroups when namespaces are
> unshared - something of an experimental feature, which I think really
> needs more complete container/namespace support in order to be useful.
> I suspect the only users are Cedric and Serge, or maybe a few others
> on containers@lists.linux-foundation.org. And in fact it would only be
> noticed by the users who make the assumption about how the name is
> generated, rather than getting it from the /proc/<pid>/cgroups file
> for the process in question.
> 
> Whether the change is actually needed or not I'm fairly agnostic on,
> but I guess it is more elegant to just use the pid as the new group
> name rather than adding a fairly arbitrary "node_" prefix on the
> front.
> 

Well I suppose that as a non-back-compatible change we should feed it
into 2.6.25.x as well.  It's a bit unusual, but so doing will reduce the
number of hey-where-did-my-file-go discoveries.
