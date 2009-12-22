Return-Path: <linux-kernel-owner+w=401wt.eu-S1751473AbZLVAx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbZLVAx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 19:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbZLVAx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 19:53:58 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:49294 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750935AbZLVAx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 19:53:58 -0500
Date: Mon, 21 Dec 2009 19:53:50 -0500 (EST)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: richard -rw- weinberger <richard.weinberger@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] um: CONFIG_STATIC_LINK=y broken
In-Reply-To: <2b41c200912211639p30927d84k9253ac7c90ac0e68@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0912211944050.19919@dr-wily.mit.edu>
References: <2b41c200912211621p72eceed5tb9f9711b2f96b72e@mail.gmail.com>  <alpine.DEB.1.10.0912211926100.19919@dr-wily.mit.edu> <2b41c200912211639p30927d84k9253ac7c90ac0e68@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Dec 2009, richard -rw- weinberger wrote:

> This is the bad changeset:

Thanks for tracking that down.  INIT_TEXT_SECTION is:

#define INIT_TEXT_SECTION(inittext_align)                               \
        . = ALIGN(inittext_align);                                      \
        .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {               \
                VMLINUX_SYMBOL(_sinittext) = .;                         \
                INIT_TEXT                                               \
                VMLINUX_SYMBOL(_einittext) = .;                         \
        }

So there are only 3 code changes here:
(1) wrapping _sinittext and _einittext in VMLINUX_SYMBOL
(2) Adding the AT(ADDR(.init.text) - LOAD_OFFSET)
(3) The added ALIGN(PAGE_SIZE) before the start of .init.text.

I don't yet see why any of these would be problematic; would you be 
willing to try them and figure out the precise cause?

I suspect it'd be easiest for you to try those individual changes 
interactively, but if it's not trivial for you, I'd be happy to generate a 
patch series splitting out this change into pieces for you to bisect.

	-Tim Abbott
