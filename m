Return-Path: <linux-kernel-owner+w=401wt.eu-S1752561AbZIXWVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbZIXWVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbZIXWVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:21:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54403 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZIXWVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:21:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Oren Laadan <orenl@librato.com>
Subject: Re: [RFC][v7][PATCH 0/9] Implement clone2() system call
Date: Fri, 25 Sep 2009 00:21:03 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-10-generic; KDE/4.3.1; x86_64; ; )
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
References: <20090924165548.GA16586@us.ibm.com> <20090924201517.GA24786@us.ibm.com> <4ABBED72.9080901@librato.com>
In-Reply-To: <4ABBED72.9080901@librato.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909250021.03535.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+wR+KJIqD83dXAy8j2vScWtwU/mQz7EGOPWx8
 c7Uzb95igVpxW/OhQOeORCLfAHhqxYSgY45ZSkMFL8T9jqpOGH
 dLQfzTML9TP9lXRQPO21Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 September 2009, Oren Laadan wrote:
> In this form, you place a constraints on where userspace may
> place the {parent,child}_tid variable, and require that this
> particular clone_struct remain valid memory in the parent until
> the child terminates.  This may break existing programs that
> use this (threads libraries ?)

No existing program uses sys_clone2, and the kernel function
may well differ from the user space calling conventions, which
are not bound by the six-argument limitation.

So a clone2 library call could set up the structure with the
arguments to the real syscall, call into the kernel and
copy the output data back into the pointers it was given by
the user.

	Arnd <><
