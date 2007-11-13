Return-Path: <linux-kernel-owner+w=401wt.eu-S1762043AbXKMWjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762043AbXKMWjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756997AbXKMWiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:38:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59850 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbXKMWiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:38:54 -0500
Message-ID: <473A26A2.7090007@zytor.com>
Date: Tue, 13 Nov 2007 14:35:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization (update)
References: <20071113185800.436425570@polymtl.ca> <20071113190040.740103668@polymtl.ca> <4739F609.50501@zytor.com> <20071113192445.GA1463@Krystal> <4739FCA0.4040702@zytor.com> <20071113194550.GA4400@Krystal> <473A017D.2030501@zytor.com> <20071113204033.GB7450@Krystal> <473A166E.3070708@zytor.com> <20071113220227.GB9057@Krystal>
In-Reply-To: <20071113220227.GB9057@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> Andi seemed to trust gas stability and you answered:
> 
> "The comment was referring to x86-64, but I incorrectly remembered that 
> applying to "movq $imm,%reg" as opposed to loading from an absolute 
> address.  gas actually has a special opcode (movabs) for the 64-bit 
> version of the latter variant, which is only available with %rax and its 
> subregisters.
> 
> Nevermind, in other words.  It's still true, though, that the immediate 
> will always be the last thing in the instruction -- that's a fixture of 
> the instruction format."
> 
> So, in the end, is there a way to make x86_64 use a fixed-size opcode
> for the 1, 2, 4 and 8 bytes load immediates or we will have to force the
> use of a specific register ?
> 
> (and we can't take a pointer from the end of the instruction, because we
> need to align the immediate value correctly)
> 

For a 64-bit load, you'll always have a REX prefix.  For 8-, 16- and 
32-bit load, the length of the instruction will depend on the register 
chosen, unless you constrain to either all legacy or all upper 
registers, or you force gas to generate a prefix, but I don't think 
there is a way to do that that will work with assemblers all the way 
back to 2.12, which is at least what we officially support (I have no 
idea if assemblers that far back actually *work*, mind you.)

	-hpa
