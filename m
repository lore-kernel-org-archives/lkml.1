Return-Path: <linux-kernel-owner+w=401wt.eu-S1755754AbYGXNZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754AbYGXNZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYGXNZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:25:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41367 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbYGXNZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:25:01 -0400
Message-ID: <48888289.4040001@zytor.com>
Date: Thu, 24 Jul 2008 09:24:25 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Joerg Roedel <joro@8bytes.org>, mingo@elte.hu,
       Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: improve double fault handling
References: <4880A912.76E4.0078.0@novell.com> <20080723214320.GC13662@8bytes.org> <4888467F.76E4.0078.0@novell.com>
In-Reply-To: <4888467F.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Joerg Roedel <joro@8bytes.org> 23.07.08 23:43 >>>
>> On Fri, Jul 18, 2008 at 01:30:42PM +0100, Jan Beulich wrote:
>>> Make the double fault handler use CPU-specific stacks. Add some
>>> abstraction to simplify future change of other exception handlers to go
>>> through task gates.
>> What is the benefit of exception handlers going through task gates?
>> Hardware task switches are not very well supported in virtualization
>> (e.g. its has issues in KVM and is also not in Xen for a long time).
> 
> The main goal is to get to a different stack. While at present this is done
> only for the double fault, I think generally NMI and MCE should also do
> so, as they may be caused by a stack access (see x86-64, which runs
> them on IST stacks), and hence continuing to run on that same stack
> may not allow the exception to be handled.

NMI, MCE and #DF are the obvious candidates.

Now, keep in mind TSSes have to be prepared per-CPU, since they get 
marked "busy" when in use, so it's a bit of a nontrivial undertaking.

	-hpa

