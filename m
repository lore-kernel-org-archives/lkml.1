Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbXCLU0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbXCLU0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbXCLU0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:26:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55750 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752868AbXCLU0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:26:33 -0400
Date: Mon, 12 Mar 2007 13:26:32 -0700
From: Paul Jackson <pj@sgi.com>
To: vatsa@in.ibm.com
Cc: herbert@13thfloor.at, ebiederm@xmission.com, menage@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru, winget@google.com, containers@lists.osdl.org,
       akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka
 containers on top of nsproxy!
Message-Id: <20070312132632.2397a393.pj@sgi.com>
In-Reply-To: <20070312140148.GA10450@in.ibm.com>
References: <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
	<45EF5A62.8000103@vilain.net>
	<6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>
	<45EF5E71.7090101@vilain.net>
	<6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>
	<m1d53ka5b9.fsf@ebiederm.dsl.xmission.com>
	<20070309005357.GC4506@MAIL.13thfloor.at>
	<20070309181908.GC21661@in.ibm.com>
	<20070309215218.GA17592@MAIL.13thfloor.at>
	<20070309140603.b2b162c6.pj@sgi.com>
	<20070312140148.GA10450@in.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vatsa wrote:
> This assumes that you can see the global vfs namespace right?
> 
> What if you are inside a container/vserver which restricts your vfs
> namespace? i.e /dev/cpusets seen from one container is not same as what
> is seen from another container .

Well, yes.  But that restriction on the namespace is no doing of
cpusets.

It's some vfs namespace restriction, which should be an orthogonal
mechanism.

Well, it's probably not orthogonal at present.  Cpusets might not yet
handle a restricted vfs name space very well.

For example the /proc/<pid>/cpuset path, giving path below /dev/cpuset
of task pid's cpuset, might not be restricted.  And the set of all CPUs
and Memory Nodes that are online, which is visible in various /proc
files, and also visible in ones top cpuset, might be inconsistent if
restricted vfs namespace mapped you to a different top cpuset.

There are probably other loose ends as well.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
