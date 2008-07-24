Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbYGXHHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbYGXHHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 03:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750832AbYGXHHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 03:07:46 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:50259 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYGXHHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 03:07:46 -0400
Message-Id: <4888467F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 24 Jul 2008 08:08:15 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Joerg Roedel" <joro@8bytes.org>
Cc: <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] i386: improve double fault handling
References: <4880A912.76E4.0078.0@novell.com>
 <20080723214320.GC13662@8bytes.org>
In-Reply-To: <20080723214320.GC13662@8bytes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Joerg Roedel <joro@8bytes.org> 23.07.08 23:43 >>>
>On Fri, Jul 18, 2008 at 01:30:42PM +0100, Jan Beulich wrote:
>> Make the double fault handler use CPU-specific stacks. Add some
>> abstraction to simplify future change of other exception handlers to go
>> through task gates.
>
>What is the benefit of exception handlers going through task gates?
>Hardware task switches are not very well supported in virtualization
>(e.g. its has issues in KVM and is also not in Xen for a long time).

The main goal is to get to a different stack. While at present this is done
only for the double fault, I think generally NMI and MCE should also do
so, as they may be caused by a stack access (see x86-64, which runs
them on IST stacks), and hence continuing to run on that same stack
may not allow the exception to be handled.

Jan

