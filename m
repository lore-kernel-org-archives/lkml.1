Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYJOPQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYJOPQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 11:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYJOPQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 11:16:06 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:56599 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbYJOPQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 11:16:05 -0400
Message-ID: <48F6092D.6050400@fr.ibm.com>
Date: Wed, 15 Oct 2008 17:15:57 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, jeremy@goop.org, arnd@arndb.de,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrey Mirkin <major@openvz.org>
Subject: Re: [RFC v6][PATCH 0/9] Kernel based checkpoint/restart
References: <1223461197-11513-1-git-send-email-orenl@cs.columbia.edu> <20081009124658.GE2952@elte.hu> <1223557122.11830.14.camel@nimitz> <20081009131701.GA21112@elte.hu> <1223559246.11830.23.camel@nimitz> <20081009134415.GA12135@elte.hu> <1223571036.11830.32.camel@nimitz> <20081010153951.GD28977@elte.hu>  <48F30315.1070909@fr.ibm.com> <1223916223.29877.14.camel@nimitz>
In-Reply-To: <1223916223.29877.14.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Mon, 2008-10-13 at 10:13 +0200, Cedric Le Goater wrote:
>> hmm, that's rather complex, because we have to take into account the 
>> kernel stack, no ? This is what Andrey was trying to solve in his patchset 
>> back in September :
>>
>>         http://lkml.org/lkml/2008/9/3/96
>>
>> the restart phase simulates a clone and switch_to to (not) restore the kernel 
>> stack. right ? 
> 
> Do we ever have to worry about the kernel stack if we simply say that
> tasks have to be *in* userspace when we checkpoint them. 

at a syscall boundary for example. that would make our life easier 
definitely. 

C.

> If a task is
> in an uninterruptable wait state, I'm not sure it's safe to checkpoint
> it anyway.

