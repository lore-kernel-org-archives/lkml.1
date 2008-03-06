Return-Path: <linux-kernel-owner+w=401wt.eu-S1764656AbYCFAuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764656AbYCFAuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 19:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758499AbYCFAuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 19:50:04 -0500
Received: from hall.aurel32.net ([88.191.38.19]:38380 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758175AbYCFAuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 19:50:03 -0500
Message-ID: <47CF3F87.3090709@aurel32.net>
Date: Thu, 06 Mar 2008 01:49:11 +0100
From: Aurelien Jarno <aurelien@aurel32.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: Chris Lattner <clattner@apple.com>
CC: Michael Matz <matz@suse.de>, "H.Peter Anvin" <hpa@zytor.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
 flag
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com> <20080305204945.GB14011@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> <20080305212005.GC17267@synopsys.com> <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> <47CF11D6.7070901@zytor.com> <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com> <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de> <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com>
In-Reply-To: <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Lattner a écrit :
>>>> Richard Guenther wrote:
>>>>> We didn't yet run into this issue and build openSUSE with 4.3 since
>>>>> more
>>>>> than
>>>>> three month.
>>>>
>>>> Well, how often do you take a trap inside an overlapping memmove()?
>>>
>>> How hard is it to change the kernel signal entry path from "pushf" to
>>> "pushf;cld"?  Problem solved, no?
>>
>> The problem is with old kernels, which by definition stay unfixed.
> 
> My impression was that the problem occurs in GCC compiled code in the
> kernel itself, not in user space:
> 
> 1. User space has direction flag set.
> 2. signal occurs
> 3. kernel code is entered
> 4. kernel code does string operation <boom>

Wrong. Except maybe for the Hurd kernel. For other kernels:

  4. signal handler is called
  5. signal handler does string operation <boom>

The GCC used to compile the kernel doesn't matter. Using gcc 4.3 to
compile the user code triggers the bug.

-- 
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
