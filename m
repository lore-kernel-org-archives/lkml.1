Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbYGJOw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbYGJOw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbYGJOwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:52:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbYGJOwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:52:19 -0400
Date: Thu, 10 Jul 2008 10:48:52 -0400
From: Rik van Riel <riel@redhat.com>
To: "Paul Menage" <menage@google.com>
Cc: "Vivek Goyal" <vgoyal@redhat.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Libcg Devel Mailing List" <libcg-devel@lists.sourceforge.net>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Peter Zijlstra" <pzijlstr@redhat.com>,
       "Kazunaga Ikeno" <k-ikeno@ak.jp.nec.com>,
       "Morton Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Graf" <tgraf@redhat.com>
Subject: Re: [RFC] How to handle the rules engine for cgroups
Message-ID: <20080710104852.797fe79c@cuia.bos.redhat.com>
In-Reply-To: <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com>
References: <20080701191126.GA17376@redhat.com>
	<20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com>
	<20080703155446.GB9275@redhat.com>
	<6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 02:23:52 -0700
"Paul Menage" <menage@google.com> wrote:

> I don't see the rule-based approach being all that useful for our needs.

Agreed, there really is no need for a rule-based approach in kernel space.

There are basically three different cases:

1) daemons get started up in their own process groups, this can
   be handled by the initscripts

2) user sessions (ssh, etc) start in their own process groups,
   this can be handled by PAM

3) users fork processes that should go into special process
   groups - this could be handled by having a small ruleset
   in userspace handle things, right before calling exec(),
   it can even be hidden from the application by hooking into
   the exec() call

If a user overrides the rules for their own processes, at worst
s/he takes away resources from him/herself.  No security problem.

Is there any reason at all to push for a kernel side rule-based
engine, except "I want to make my patch set unmergeable?"

-- 
All Rights Reversed
