Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbZBST5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbZBST5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 14:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZBST46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 14:56:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55767 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbZBST46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 14:56:58 -0500
Message-ID: <499DB8BA.3050708@zytor.com>
Date: Thu, 19 Feb 2009 11:53:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Petr Tesarik <ptesarik@suse.cz>, Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove unneeded endless loop in BUG()
References: <1235068713.15053.99.camel@nathan.suse.cz> <20090219185935.GA21820@elte.hu>
In-Reply-To: <20090219185935.GA21820@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> the problem is that the DO_BUG() will generate the u2d 
> instruction into a random place where GCC puts it. It certainly 
> wont be in the place where the __bug_table logic above expects 
> it.
> 
> The result will be cryptic crashes instead of a clean BUG 
> message assert.
> 

For that to happen, it would have to move the asm volatile relative to 
the __builtin_trap(), which seems slightly unlikely -- are there any 
cases at which this has been known to happen, or is that conjecture on 
your part?

It would be more of a "right thing" to do this with a label on the 
__builtin_trap(), but the problem with that labels have function scope 
even if they occur inside a block.

	-hpa

