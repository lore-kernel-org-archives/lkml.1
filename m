Return-Path: <linux-kernel-owner+w=401wt.eu-S1760303AbZEMOjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303AbZEMOjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758744AbZEMOjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:39:31 -0400
Received: from gw.goop.org ([64.81.55.164]:45537 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757959AbZEMOja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:39:30 -0400
Message-ID: <4A0ADBA2.2020300@goop.org>
Date: Wed, 13 May 2009 07:39:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
References: <1242170864-13560-1-git-send-email-jeremy@goop.org> <20090513133021.GA7277@elte.hu>
In-Reply-To: <20090513133021.GA7277@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i never got a reply to my question for your previous submission:
>
>   http://lkml.indiana.edu/hypermail/linux/kernel/0905.1/00152.html
>   

That was in response to the mtrr patch in the dom0/core series.

> Please dont post patches with ugly TODO items in them.
I removed them in the repost.
> Also, a more general objection is that /proc/mtrr is a legacy
> interface, we dont really want to extend its use.
It's not an extended use; its just making the existing interface work 
under Xen (ie, not breaking the userspace ABI).  The only other 
alternatives would be to 1) use Kconfig to prevent MTRR and Xen from 
being set at the same time, or 2) put a runtime hack in to disable MTRR 
when running under Xen.  Neither seems like a good idea when we can just 
keep the interface working.
> The Xen hypervisor
> should get proper PAT support instead ...

Well, it has PAT support, but there's an issue that the Xen PAT setup 
isn't quite the same as Linux's (but I thought you were cc:d on the 
discussion about that).  We need to sort out some details about the 
precise mechanism, but it looks like we'll be able to support PAT in 
Linux guests relatively easily (but not immediately).

    J
