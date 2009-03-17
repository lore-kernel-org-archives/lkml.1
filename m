Return-Path: <linux-kernel-owner+w=401wt.eu-S1757007AbZCQP4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007AbZCQP4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 11:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZCQP4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 11:56:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55288 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbZCQP4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:56:06 -0400
Message-ID: <49BFC64F.4080300@zytor.com>
Date: Tue, 17 Mar 2009 08:48:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jan Beulich <jbeulich@novell.com>, Arjan van de Ven <arjan@infradead.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: mask XSAVE from cpuid
References: <49BA3A84.76E4.0078.0@novell.com> <49BA7810.6090807@goop.org> <49BD4CE1.6040100@zytor.com> <49BD6D0E.1010107@goop.org> <20090315154718.00353625@infradead.org> <49BD97C6.2070401@goop.org> <20090315170945.08344b86@infradead.org> <49BE6D50.76E4.0078.0@novell.com> <87fxhd2f53.fsf@basil.nowhere.org> <49BEFDFB.8070900@zytor.com> <20090317115621.GQ11935@one.firstfloor.org>
In-Reply-To: <20090317115621.GQ11935@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> The point is YOU DON'T KNOW.  In particular, there might be new traps,
>> there might be new state, there might be new MSRs, there might be new
>> control bits... anything.  Therefore, you cannot blindly pass the bit
>> on, even though XSAVE solves one part of the problem.
> 
> I think what will happen if you don't expose it is that there will
> be always hypervisors which are behind and applications/OS will end up
> doing probing for opcodes instead of trusting CPUID bits.
> 
> Probably not what you intended.
> 

Probing for opcodes is even more harmful, though.  But yes, we don't
have a good answer to this, and I believe we *can't* have a good answer
to this either -- we could architect the CPUID instruction a bit
differently, but that doesn't account for the various needs of
differnent hypervisors.

Hypervisor vendors can of course make this easier by making their CPUID
code pluggable so the end user can "hotfix" upgrade it without upgrading
the hypervisor (which makes a lot of them nervous.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

