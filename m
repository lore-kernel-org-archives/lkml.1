Return-Path: <linux-kernel-owner+w=401wt.eu-S1755969AbYGNOrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbYGNOrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 10:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbYGNOrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 10:47:33 -0400
Received: from brmea-mail-1.Sun.COM ([192.18.98.31]:43900 "EHLO
	brmea-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbYGNOrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 10:47:32 -0400
Date: Mon, 14 Jul 2008 10:44:43 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Re: [RFC] How to handle the rules engine for cgroups
In-reply-to: <20080714135719.GE16673@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Paul Menage <menage@google.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>, Ulrich Drepper <drepper@redhat.com>
Reply-to: davecb@sun.com
Message-id: <487B665B.9080205@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <20080701191126.GA17376@redhat.com>
 <20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com>
 <20080703155446.GB9275@redhat.com>
 <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com>
 <20080710104852.797fe79c@cuia.bos.redhat.com>
 <20080710154035.GA12043@redhat.com>
 <20080711095501.cefff6df.kamezawa.hiroyu@jp.fujitsu.com>
 <20080714135719.GE16673@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> If admin has decided to group applications and has written the rules for
> it then applications should not know anything about grouping. So I think
> application writing an script for being placed into the right group should
> be out of question. Now how does an admin write a wrapper around existing
> application without breaking anything else.

In the Solaris world, processes are placed into cgroups (projects) by
one of two mechanisms:

1) inheritance, with everything I create in my existing project.
   To get this started, there is a mechanism under login/getty/whatever 
   reading the /etc/projects file and, for example, tossing user davecb 
   into a "user.davecb" project.

2) explicit placement with newtask, which starts a program or moves
   a process into a project/cgroup

I have a "bg" project which I use for limiting resource consumption of
background jobs, and a background command which either starts or moves
jobs, thusly:

 case "$1" in
 [0-9]*) # It's a pid
         newtask -p bg -c $1
         ;;
  *) # It's a command-line
         newtask -p bg "$@" &
         ;;
  esac

A rules engine would be more useful for managing workloads once
they're assigned, as IBM does on the mainframe with WLM and goal-directed
resource management. (They're brilliant in this area, by the way, so
I'd be inclined to steal ideas from them  (;-))

--dave
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
(905) 943-1983, cell: (647) 833-9377, (800) 555-9786 x56583
bridge: (877) 385-4099 code: 506 9191#
