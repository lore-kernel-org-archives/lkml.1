Return-Path: <linux-kernel-owner+w=401wt.eu-S1759348AbYEMRE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348AbYEMRE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbYEMRET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:04:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41175 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbYEMRES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:04:18 -0400
Message-ID: <4829C9EE.7020306@zytor.com>
Date: Tue, 13 May 2008 10:03:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: Re: [patch 1/2] x86: head_64.S cleanup - use straight move to CR4
 register
References: <20080513165538.952646389@gmail.com>> <4829c921.0305560a.489b.07db@mx.google.com>
In-Reply-To: <4829c921.0305560a.489b.07db@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> There is no need for testing the values because we already know
> what they should be. Just set them in straight way.

He isn't testing them, he's setting individual bits.

Either of these is pretty silly; the right way to do this is:

	movl	$(X86_CR4_PAE|X86_CR4_PGE), %eax
	movq	%rax, %cr4

A movl in 64-bit mode zero extends.

	-hpa
