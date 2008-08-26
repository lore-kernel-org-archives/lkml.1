Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbYHZQbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbYHZQbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbYHZQa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:30:58 -0400
Received: from brmea-mail-3.Sun.COM ([192.18.98.34]:42866 "EHLO
	brmea-mail-3.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbYHZQa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:30:58 -0400
Date: Tue, 26 Aug 2008 12:32:26 -0400
From: David Collier-Brown <davecb@sun.com>
Subject: Re: [RFC] [PATCH -mm] cgroup: uid-based rules to add processes
	efficiently in the right cgroup
In-reply-to: <20080826160007.GE30312@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: balbir@linux.vnet.ibm.com, Paul Menage <menage@google.com>,
       righi.andrea@gmail.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Steve Olivieri <solivier@redhat.com>
Reply-to: davecb@sun.com
Message-id: <48B4301A.5010600@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <20080714135719.GE16673@redhat.com> <487B665B.9080205@sun.com>
 <20080714152142.GJ16673@redhat.com> <48A7FE7B.3060309@gmail.com>
 <6599ad830808181405i3ec1f9fdp4d8ca7ab675b2c5f@mail.gmail.com>
 <20080819125710.GA18972@redhat.com>
 <6599ad830808251754l146588dax65aeff2cc22ac0c1@mail.gmail.com>
 <20080826134127.GA30312@redhat.com> <48B414A0.9000504@linux.vnet.ibm.com>
 <48B41B8A.70301@sun.com> <20080826160007.GE30312@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; SunOS sun4u; en-US; rv:1.7) Gecko/20041221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Vivek Goyal wrote:
> Who executes default rules? IOW, how do you make sure tasks of user.davecb
> end up in project 101 only and not outside?

A classifier at login/connect starts each new process off in the correct group.
New processes inherit their parent's group unless you use newtask or su.

> So by default all the tasks of user.davecb will run into project 101 until
> user davecb decides to launch some background jobs in project 100 using
> newtask?

That's right, the and cgexec-like "newtask" is what I use
to script things: for example, my background script says

       case "$1" in
        [0-9]*) # It's a pid
                newtask -p bg -c $1
                ;;
        *) # It's a command-line
                newtask -p bg "$@" &
                ;;
        esac

There's also an -F option to put a process into a cgroup
and never let it newtask itself or it's children to another one,
so that software from Dr Evil, Inc. can't do privilege 
escalation (;-))

--dave
-- 
David Collier-Brown            | Always do right. This will gratify
Sun Microsystems, Toronto      | some people and astonish the rest
davecb@sun.com                 |                      -- Mark Twain
cell: (647) 833-9377, bridge: (877) 385-4099 code: 506 9191#
