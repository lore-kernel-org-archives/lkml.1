Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbYJOW0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbYJOW0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 18:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYJOW03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 18:26:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35610 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751969AbYJOW02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 18:26:28 -0400
Date: Wed, 15 Oct 2008 23:26:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Steve Kemp <steve@steve.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: trivial patches: Should we care about control reaches end of
 non-void function
Message-ID: <20081015232625.547ebe9e@lxorguk.ukuu.org.uk>
In-Reply-To: <20081015180732.GA4119@steve.org.uk>
References: <20081015180732.GA4119@steve.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   I see some functions in the kernel have added "return 0" after the
>  BUG, presumably to silence these warnings.  Would a patch to do this
>  consistently, or is that too trivial even for trivial patches?

Probably better to mark BUG() properly for the compiler.

If you can get __attribute((__noreturn__)) on the end of the BUG function
somehow say

static inline void bug_off(void) __attribute((__noreturn__)) {};

and expanded that onto the end of the macro maybe it would shut up

Alan
