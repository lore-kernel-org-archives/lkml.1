Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbZIMOiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbZIMOiK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 10:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbZIMOiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 10:38:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52518 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbZIMOiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 10:38:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [RFC][v6][PATCH 0/9] clone_with_pids() syscall
Date: Sun, 13 Sep 2009 16:36:47 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-9-generic; KDE/4.3.1; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>,
       container@us.ibm.com, sukadev@us.ibm.com
References: <20090910060627.GA24343@us.ibm.com> <1252688404.7126.40.camel@laptop> <20090912171930.GB29169@us.ibm.com>
In-Reply-To: <20090912171930.GB29169@us.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909131636.47407.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+byQMfXFEO8JPuEJ7lnV3aH5kyrlXujUvrNYs
 dRCdQUsEURnhPOnSMWd4YRZ/bRtKmb/vWYu3Xw0uSP2x1QHJUM
 ZyL98/puFPYyrUu9qqtBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 September 2009, Sukadev Bhattiprolu wrote:
> 
> Peter Zijlstra [peterz@infradead.org] wrote:
> | On Fri, 2009-09-11 at 09:47 -0700, Sukadev Bhattiprolu wrote:
> | > | Also, if you're passing a struct, why not put nr_pids in there, and
> | > | replace clone_pid_struct with a simple array? That would give us
> | > | 
> | > | struct clone_struct {
> | > |         u64 flags;
> | > |         u64 child_stack;
> | > |         u32 child_tid;
> | > |         u32 parent_tid;
> 
> BTW, these two tids are __user pointers that kernel copies data into.
> They should be u64 to avoid conversions in architecture specific code ?
> 

No, they are not pointers, the kernel can directly write into the user
data structure. Indirect pointers would not be helpful here IMHO.

	Arnd <><
