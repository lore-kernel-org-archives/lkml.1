Return-Path: <linux-kernel-owner+w=401wt.eu-S2993150AbXCIWGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993150AbXCIWGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993149AbXCIWGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:06:05 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55148 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933410AbXCIWGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:06:04 -0500
Date: Fri, 9 Mar 2007 14:06:03 -0800
From: Paul Jackson <pj@sgi.com>
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: vatsa@in.ibm.com, ebiederm@xmission.com, menage@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru, winget@google.com, containers@lists.osdl.org,
       akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka
 containers on top of nsproxy!
Message-Id: <20070309140603.b2b162c6.pj@sgi.com>
In-Reply-To: <20070309215218.GA17592@MAIL.13thfloor.at>
References: <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
	<m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>
	<6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
	<45EF5A62.8000103@vilain.net>
	<6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>
	<45EF5E71.7090101@vilain.net>
	<6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>
	<m1d53ka5b9.fsf@ebiederm.dsl.xmission.com>
	<20070309005357.GC4506@MAIL.13thfloor.at>
	<20070309181908.GC21661@in.ibm.com>
	<20070309215218.GA17592@MAIL.13thfloor.at>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> the emphasis here is on 'from inside' which basically
> boils down to the following:
> 
>  if you create a 'resource container' to limit the
>  usage of a set of resources for the processes
>  belonging to this container, it would be kind of
>  defeating the purpose, if you'd allow the processes
>  to manipulate their limits, no?

Wrong - this is not the only way.

For instance in cpusets, -any- task in the system, regardless of what
cpuset it is currently assigned to, might be able to manipulate -any-
cpuset in the system.

Yes -- some sufficient mechanism is required to keep tasks from
escalating their resources or capabilities beyond an allowed point.

But that mechanism might not be strictly based on position in some
hierarchy.

In the case of cpusets, it is based on the permissions on files in
the cpuset file system (normally mounted at /dev/cpuset), versus
the current priviledges and capabilities of the task.

A root priviledged task in the smallest leaf node cpuset can manipulate
every cpuset in the system.  This is an ordinary and common occurrence.

I say again, as you seem to be skipping over this detail, one
advantage of basing an API on a file system is the usefulness of
the file system permission model (the -rwxrwxrwx permissions and
the uid/gid owners on each file and directory node).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
