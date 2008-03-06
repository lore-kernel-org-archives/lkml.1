Return-Path: <linux-kernel-owner+w=401wt.eu-S934140AbYCFAmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934140AbYCFAmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 19:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765880AbYCFAgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 19:36:45 -0500
Received: from mail-out4.apple.com ([17.254.13.23]:55301 "EHLO
	mail-out4.apple.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531AbYCFAgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 19:36:44 -0500
X-AuditID: 11807130-ac0d3bb0000008b8-c3-47cf3c9abce5
Cc: "H.Peter Anvin" <hpa@zytor.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Message-Id: <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com>
From: Chris Lattner <clattner@apple.com>
To: Michael Matz <matz@suse.de>
In-Reply-To: <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Date: Wed, 5 Mar 2008 16:36:41 -0800
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com> <20080305204945.GB14011@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> <20080305212005.GC17267@synopsys.com> <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> <47CF11D6.7070901@zytor.com> <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com> <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de>
X-Mailer: Apple Mail (2.919.2)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Richard Guenther wrote:
>>>> We didn't yet run into this issue and build openSUSE with 4.3  
>>>> since more
>>>> than
>>>> three month.
>>>
>>> Well, how often do you take a trap inside an overlapping memmove()?
>>
>> How hard is it to change the kernel signal entry path from "pushf" to
>> "pushf;cld"?  Problem solved, no?
>
> The problem is with old kernels, which by definition stay unfixed.

My impression was that the problem occurs in GCC compiled code in the  
kernel itself, not in user space:

1. User space has direction flag set.
2. signal occurs
3. kernel code is entered
4. kernel code does string operation <boom>

Fixing this instance of the problem by changing GCC requires (at  
least) recompiling the kernel.

Changing the ABI for this seems like a pretty crazy solution to a very  
minor and easily fixable kernel bug.  Distros have control over what  
kernels they ship, they have absolute power to ensure this doesn't  
affect their users when running default kernels - without changing the  
compiler.

-Chris
