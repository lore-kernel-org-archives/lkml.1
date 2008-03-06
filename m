Return-Path: <linux-kernel-owner+w=401wt.eu-S1765886AbYCFBWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765886AbYCFBWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 20:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759559AbYCFBQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 20:16:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53807 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759943AbYCFBQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 20:16:07 -0500
Message-ID: <47CF44E7.3020106@zytor.com>
Date: Wed, 05 Mar 2008 17:12:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Chris Lattner <clattner@apple.com>
CC: Michael Matz <matz@suse.de>, Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Jan Hubicka <hubicka@ucw.cz>,
       Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
 flag
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com> <20080305204945.GB14011@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> <20080305212005.GC17267@synopsys.com> <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> <47CF11D6.7070901@zytor.com> <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com> <Pine.LNX.4.64.0803052258530.20583@wotan.suse.de> <2F47E21A-9055-4EC3-99CF-B666BBC045C3@apple.com> <47CF3F09.4080606@zytor.com> <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com>
In-Reply-To: <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Lattner wrote:
>>
>> Upon return to userspace, the modified state kicks in.  Thus the 
>> signal handler is entered with DF from userspace at trap time, not DF=0.
>>
>> So it's an asynchronous state leak from one piece of userspace to 
>> another.
> 
> Fine, it can happen either way.  In either case, the distro vendor 
> should fix the the signal handler in the kernels they distribute.  If 
> you don't do that, you are still leaking information from one piece of 
> user space code to another, you're just papering over it in a horrible 
> way :)
> 
> GCC defines the direction flag to be clear before inline asm. Enforcing 
> the semantics you propose would require issuing a cld before every 
> inline asm, not just before every string operation.
> 

It's a kernel bug, and it needs to be fixed.  The discussion is about 
what to do in the meantime.

(And yes, you're absolutely right: between global subroutine entry and 
the first asm or string operation, you'd have to emit cld.)

	-hpa
