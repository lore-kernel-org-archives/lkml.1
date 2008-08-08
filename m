Return-Path: <linux-kernel-owner+w=401wt.eu-S1764570AbYHHWaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764570AbYHHWaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763353AbYHHW3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:29:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:54646 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762927AbYHHW3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:29:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [RFC][PATCH 2/4] checkpoint/restart: x86 support
Date: Sat, 9 Aug 2008 00:29:27 +0200
User-Agent: KMail/1.9.9
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Theodore Tso <tytso@mit.edu>, "Serge E. Hallyn" <serue@us.ibm.com>
References: <20080807224033.FFB3A2C1@kernel> <200808081409.30591.arnd@arndb.de> <489CAC70.7090809@cs.columbia.edu>
In-Reply-To: <489CAC70.7090809@cs.columbia.edu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808090029.28286.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/U4qIub63yyem8q2TFjTxQNE757MPJQBlAxni
 xvV1bWZFpmQrYdlwwmua6MMiXH2BYtcFvi3dZTQ64/N+Ys38I8
 Az25Q+nlxBt4nZfJE6E9A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 August 2008, Oren Laadan wrote:

> > It seems weird that you use __u64 members for the registers, but don't
> > include r8..r15 in the list. As a consequence, this structure does not
> > seem well suited for either x86-32 or x86-64.
> 
> In the context of CR, x86-32 and x86-64 are distinct architectures because
> you cannot always migrate from one to the other (though 32->64 is sometimes
> possible). Therefore, each architecture can have a separate checkpoint file
> format (eg r8..r15 only for x86-64).

So why do you use __u64 members for your 32 bit registers?

> Except for this special case (32 bit running 64 bit), simple conversion can
> be done in the kernel if needed, but most conversion between kernel the
> format for different kernel versions (should it change) can be done in
> user space (eg. with a filter).

The 32bit on 64bit case is quite common on non-x86 architectures, e.g.
powerpc or sparc, where 64 bit kernels typically run 32 bit user space.

A particularly interesting case is mixing 32 and 64 bit tasks in a container
that you are checkpointing. This is a very realistic scenario, so there
may be good arguments for keeping the format identical between the variations
of each architecture.

> > I would suggest either using struct pt_regs by reference, or defining
> > it so that you can use the same structure for both 32 and 64 bit x86.
> 
> We prefer not to use the kernel structure directly, but an intermediate
> structure that can help mitigate subtle incompatibilities issues (between
> kernel configurations, versions, and even compiler versions).
> 
> Anyway, either a single structure for both 32 and 64 bit x86, or separate
> "struct cr_hdr_cpu{_32,_64}", one for each architecture.

struct pt_regs is part of the kernel ABI, it will not change.

	Arnd <><


