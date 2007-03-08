Return-Path: <linux-kernel-owner+w=401wt.eu-S932406AbXCHGeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406AbXCHGeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 01:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932478AbXCHGeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 01:34:10 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34992 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406AbXCHGeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 01:34:08 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sam Vilain <sam@vilain.net>
Cc: Paul Menage <menage@google.com>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       xemul@sw.ru, dev@sw.ru, pj@sgi.com, winget@google.com,
       containers@lists.osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
References: <20070301133543.GK15509@in.ibm.com>
	<20070307205846.GB7010@sergelap.austin.ibm.com>
	<6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
	<m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>
	<6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
	<45EF5A62.8000103@vilain.net>
	<6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>
	<45EF5E71.7090101@vilain.net>
	<6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>
	<45EF793C.1000700@vilain.net>
	<6599ad830703071857yf711921ja3440c4276bbe58e@mail.gmail.com>
	<45EF83CB.9080903@vilain.net>
Date: Wed, 07 Mar 2007 23:32:17 -0700
In-Reply-To: <45EF83CB.9080903@vilain.net> (Sam Vilain's message of "Thu, 08
	Mar 2007 16:32:27 +1300")
Message-ID: <m18xe88cum.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Vilain <sam@vilain.net> writes:

> And do we bother changing IPC namespaces or let that one slide?

ipc namespaces works (if you worry about tiny details like we put
the resource limits for the sysv ipc objects inside the namespace).

Probably the most instructive example of this is that you can you
map a sysv ipc shared memory segment with shmat and then switch to
another sysvipc namespace you still have access by reads and writes
to that shared memory segment but you cannot manipulate it because it
doesn't have a name.

Either that or look at the output of ipcs, before and after an unshare.

SYSVIPC really doesn't have it's own (very weird) set of global names
and that is essentially all the ipc namespace deals with.

I think you have the sysvipc namespace confused with something else
though (like signal sending).

Eric
