Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbYLBL5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbYLBL5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 06:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYLBL5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 06:57:32 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:60011 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYLBL5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 06:57:31 -0500
Date: Tue, 2 Dec 2008 12:57:29 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Greg Kurz <gkurz@fr.ibm.com>, linux-kernel@vger.kernel.org,
       oleg@redhat.com, ebiederm@xmission.com, containers@lists.osdl.org,
       roland@redhat.com, xemul@openvz.org
Subject: Re: [RFC][PATCH 2/5] pid: Generalize task_active_pid_ns
Message-ID: <20081202115729.GB1132@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
	Greg Kurz <gkurz@fr.ibm.com>, linux-kernel@vger.kernel.org,
	oleg@redhat.com, ebiederm@xmission.com, containers@lists.osdl.org,
	roland@redhat.com, xemul@openvz.org
References: <20081126034242.GA23120@us.ibm.com> <20081126034528.GB23238@us.ibm.com> <20081127011738.GC13545@wavehammer.waldi.eu.org> <1227820765.5108.20.camel@bahia.kalilou.org> <20081201211518.GB15004@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081201211518.GB15004@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 01:15:18PM -0800, Sukadev Bhattiprolu wrote:
> Greg Kurz [gkurz@fr.ibm.com] wrote:
> | On Thu, 2008-11-27 at 02:17 +0100, Bastian Blank wrote:
> | > On Tue, Nov 25, 2008 at 07:45:28PM -0800, Sukadev Bhattiprolu wrote:
> | > > Currently task_active_pid_ns is not safe to call after a
> | > > task becomes a zombie and exit_task_namespaces is called,
> | > > as nsproxy becomes NULL.
> | > Why do you need to be able to get the pid namespace from zombie
> | > processes?
> After exiting namespaces, the process notifies parent. With new changes
> to signals (in this patchset), the signal code may need to determine
> the namespace of sender (the exiting child in this case).

So the parent of a process with a new pid namespace will never get a
SIGCHLD?

What I read in the kernel source (kernel/signal.c:do_notify_parent,
include/asm-generic/siginfo.h:CLD_EXITED) is that the exit signals
(SIGCHLD) are describes as sent by the kernel. 

> | I agree with Eric and Sukadev that task_active_pid_ns() is unsafe. There
> | isn't even a /* don't use with zombies */ in pid_namespace.h...
> Hmm. Its not unsafe at present. It would become unsafe if the signals code
> tries to determine the namespace of sender.

Why? Even now it may be used on zombie tasks.

Bastian

-- 
Vulcans do not approve of violence.
		-- Spock, "Journey to Babel", stardate 3842.4
