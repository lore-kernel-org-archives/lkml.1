Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbZDHEP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbZDHEP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 00:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbZDHEPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 00:15:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51334 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZDHEPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 00:15:15 -0400
Message-ID: <49DC24C2.7000608@zytor.com>
Date: Tue, 07 Apr 2009 21:14:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] do not keep interrupt window closed by sti in real mode
References: <1239161017-7398-1-git-send-email-glommer@redhat.com>
In-Reply-To: <1239161017-7398-1-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> While in real mode, sti does not block interrupts from the subsequent
> instruction. This is stated at Intel SDM Volume 2b, page 4-432

I don't see how you're getting that idea from the STI documentation --
and I am quite sure that that is not the case.  Quite on the contrary.
The only differences between protected mode and real mode has to do with
the handling of VIF when CPL=3 (this rather naturally falls out if one
considers CPL=0 in real mode).

The text is:

"If protected-mode virtual interrupts are not enabled, STI sets the
interrupt flag (IF) in the EFLAGS register. After the IF flag is set,
the processor begins responding to external, maskable interrupts after
the next instruction is executed. The delayed effect of this instruction
is provided to allow interrupts to be enabled just before returning from
a procedure (or subroutine). For instance, if an STI instruction is
followed by an RET instruction, the RET instruction is allowed to
execute before external interrupts are recognized1. If the STI
instruction is followed by a CLI instruction (which clears the IF flag),
the effect of the STI instruction is negated."

Obviously, in real mode, "protected-mode virtual interrupts" are not
enabled, as is also confirmed by Table 4-5.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

