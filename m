Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbYLDM7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbYLDM7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:59:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753210AbYLDM6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:58:53 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:56419 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbYLDM6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:58:52 -0500
Date: Thu, 4 Dec 2008 13:58:50 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Greg Kurz <gkurz@fr.ibm.com>, linux-kernel@vger.kernel.org,
       oleg@redhat.com, ebiederm@xmission.com, containers@lists.osdl.org,
       roland@redhat.com, xemul@openvz.org
Subject: Re: [RFC][PATCH 2/5] pid: Generalize task_active_pid_ns
Message-ID: <20081204125850.GC31061@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
	Greg Kurz <gkurz@fr.ibm.com>, linux-kernel@vger.kernel.org,
	oleg@redhat.com, ebiederm@xmission.com, containers@lists.osdl.org,
	roland@redhat.com, xemul@openvz.org
References: <20081126034242.GA23120@us.ibm.com> <20081126034528.GB23238@us.ibm.com> <20081127011738.GC13545@wavehammer.waldi.eu.org> <1227820765.5108.20.camel@bahia.kalilou.org> <20081201211518.GB15004@us.ibm.com> <20081202115729.GB1132@wavehammer.waldi.eu.org> <20081203074103.GA8487@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081203074103.GA8487@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 11:41:03PM -0800, Sukadev Bhattiprolu wrote:
> Bastian Blank [bastian@waldi.eu.org] wrote:
> | On Mon, Dec 01, 2008 at 01:15:18PM -0800, Sukadev Bhattiprolu wrote:
> | > Greg Kurz [gkurz@fr.ibm.com] wrote:
> | > | On Thu, 2008-11-27 at 02:17 +0100, Bastian Blank wrote:
> | > | > On Tue, Nov 25, 2008 at 07:45:28PM -0800, Sukadev Bhattiprolu wrote:
> | > | > > Currently task_active_pid_ns is not safe to call after a
> | > | > > task becomes a zombie and exit_task_namespaces is called,
> | > | > > as nsproxy becomes NULL.
> | > | > Why do you need to be able to get the pid namespace from zombie
> | > | > processes?
> | > After exiting namespaces, the process notifies parent. With new changes
> | > to signals (in this patchset), the signal code may need to determine
> | > the namespace of sender (the exiting child in this case).
> | So the parent of a process with a new pid namespace will never get a
> | SIGCHLD?
> I am wondering what I said that leads to that conclusion :-) If parent
> has a handler the handler will be called as usual otherwise SIGCHLD
> will be ignored.

You said you need a way to check the namespace of a zombie process. The
only signal a zombie can issue is the SIGCHLD to the parent.

> | What I read in the kernel source (kernel/signal.c:do_notify_parent,
> | include/asm-generic/siginfo.h:CLD_EXITED) is that the exit signals
> | (SIGCHLD) are describes as sent by the kernel. 
> 
> Yes. Are you suggesting a check like
> 
> 	if (!is_si_special(info) && !SI_FROMKERNEL(info)) ?
> 		/* must be from user, safe to check ns */

If "is_si_special(info) && SI_FROMKERNEL(info)" is true, there is no
need to check anything. The double negations makes this not easier to
read.

Bastian

-- 
Klingon phaser attack from front!!!!!
100% Damage to life support!!!!
