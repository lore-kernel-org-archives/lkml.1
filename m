Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbXJBHmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbXJBHmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbXJBHmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:42:37 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:56204 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbXJBHmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:42:35 -0400
Message-ID: <4701F660.8080008@nttdata.co.jp>
Date: Tue, 02 Oct 2007 16:42:24 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.6) Gecko/20070728 Thunderbird/2.0.0.6 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
CC: chrisw@sous-sol.org
Subject: Re: [TOMOYO 00/15](repost) TOMOYO Linux - MAC based on process invocation
 history.
References: <4701F285.5000206@nttdata.co.jp>
In-Reply-To: <4701F285.5000206@nttdata.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2007 07:42:25.0280 (UTC) FILETIME=[C6594000:01C804C7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007/08/27 21:11, Kyle Moffett wrote:
>This is probably not acceptable; I doubt there's a chance in hell
>that TOMOYO will get merged as long as it has text-based-language
>parsing in the kernel.  You also have $NEW_RANDOM_ABUSE_OF_PROCFS and
>$PATH_BASED_LSM_ISSUES.  See the long flamewars on AppArmor for
>discussion on the latter.

About problems of pathname-based access control and countermeasures:

TOMOYO Linux has many countermeasures that prevents many of pathname-based access control's problems.
In short, in TOMOYO Linux, attackers can't create link freely, can't rename freely,
can't manipulate namespace freely.

Not all problems can be solved (some of causes are current LSM specification),
but is enough for SOHO (Small Office/Home Office)/personal systems.

Last discussion log is at http://lkml.org/lkml/2007/8/28/113 .

About policy file handling:

Common implementations treat policy file on the filesystem as the up-to-date data,
and the kernel keeps a copy of policy file in kernel's memory.
But TOMOYO's implementation is opposite.

TOMOYO Linux has "learning mode" feature that helps administrator develop ACL (access control list).
Since the "learning mode" automatically appends entries to in-memory datastructure,
TOMOYO Linux implements in-memory datastructure using a singly-linked list
using a kind of DBMS (DataBase Management System).

TOMOYO Linux regards the ACL in kernel's DBMS as the up-to-date data
and the ACL in the policy file as a backup.
TOMOYO Linux's policy file consists of instructions for reproducing a snapshot of
ACL entries in kernel's DBMS which was saved in the past.

This is the reason why TOMOYO Linux doesn't use binary (offset-from-start-of-policy) format
for policy file, and in-kernel policy parser exists.

Last discussion log is at http://marc.info/?l=linux-security-module&m=119039218805158&w=2 .

On 2007/08/27 23:49, Paul Moore wrote:
>This has been discussed several times on various lists and is not considered 
>an acceptable solution to blocking incoming stream connection attempts.  
>Please take a look at the existing LSM stream connection request hooks as 
>well as how SELinux makes use of them.
(snip)
>Can you explain to me why this is not possible using the existing 
>security_socket_sock_rcv_skb() LSM hook?

About network hook expansion:

TOMOYO Linux makes use of userspace intervention to allow/reject connections and/or packets
based on the application's domain.
Current network-related LSM hooks can't know the final recipient of connections and/or packets.

This is the reason why TOMOYO Linux wants to add post-accept() and post-recvmsg() hooks.

Last discussion log is at http://lkml.org/lkml/2007/9/5/98 .


