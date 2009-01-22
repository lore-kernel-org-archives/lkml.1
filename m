Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZAVFsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZAVFsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 00:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZAVFsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 00:48:37 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:35329 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbZAVFsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 00:48:36 -0500
Subject: Re: [PATCH 0/7][v7] Container-init signal semantics
From: Matt Helsley <matthltc@us.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, bastian@waldi.eu.org, oleg@redhat.com,
       ebiederm@xmission.com, containers@lists.osdl.org, roland@redhat.com,
       xemul@openvz.org, "Michael Kerrisk [manpages]" <mtk-manpages@gmx.net>
In-Reply-To: <20090121030500.GA32138@us.ibm.com>
References: <20090117202638.GA11825@us.ibm.com>
	 <20090119110906.58ccbcbd.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090121030500.GA32138@us.ibm.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 21:48:31 -0800
Message-Id: <1232603311.8007.71.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 19:05 -0800, Sukadev Bhattiprolu wrote:
> KAMEZAWA Hiroyuki [kamezawa.hiroyu@jp.fujitsu.com] wrote:
> | On Sat, 17 Jan 2009 12:26:38 -0800
> | Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> wrote:
> | 
> | > 
> | > Container-init must behave like global-init to processes within the
> | > container and hence it must be immune to unhandled fatal signals from
> | > within the container (i.e SIG_DFL signals that terminate the process).
> | > 
> | > But the same container-init must behave like a normal process to 
> | > processes in ancestor namespaces and so if it receives the same fatal
> | > signal from a process in ancestor namespace, the signal must be
> | > processed.
> | > 
> | > Implementing these semantics requires that send_signal() determine pid
> | > namespace of the sender but since signals can originate from workqueues/
> | > interrupt-handlers, determining pid namespace of sender may not always
> | > be possible or safe.
> | > 
> | 
> | Is this feature is for blocking signals from children to name-space
> | creator(owner) ?  And automatically used when namespace/cgroup is created ?
> | IOW, Container-init is Namespace-Cgroup-init ? 
> 
> I am not sure what "Namespace-cgroup-init refers" to.
> 
> But, yes, this patchset applies to the first process in a pid namespace
> i.e the child of clone(NEWPID) call.
> 
> | 
> | I'm glad if you add some documentation updates about how-it-works to patch set.
> 
> Yes,  when the patchset is accepted, I am planning to add some notes to
> /sbin/init man page. 

When it's accepted I wonder if it might also be good to contact the
manpages list too so they can update the kill/signal manpages.

Cheers,
	-Matt Helsley

