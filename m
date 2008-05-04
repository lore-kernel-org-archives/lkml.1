Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbYEDLl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbYEDLl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 07:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbYEDLlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 07:41:51 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55461 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbYEDLlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 07:41:50 -0400
Date: Sun, 4 May 2008 13:42:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Roman Zippel <zippel@linux-m68k.org>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: warn about complex selects
Message-ID: <20080504114225.GA19074@uranus.ravnborg.org>
References: <19f34abd0805040156i614db705xc642b301259a4d04@mail.gmail.com> <20080504110038.GA8532@damson>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080504110038.GA8532@damson>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 01:00:38PM +0200, Vegard Nossum wrote:
> Okay, here's try #2. (That's what I get for making patches too early in the
> morning.)
> 
> This checks dependencies instead of the "default" property. I don't know how
> useful this is, though, as it will generate some false positives. Actually,
> a lot of them.

Consider following simple Kconfig:
config A
        bool "a"

config B
        bool "b"
        depends on A

config C
        bool "c"
        select B

config D
        bool "d"
        depends on A
        select B

We should try to coe up with something that warns on
on the select in "config C", because B has dependencies C
does not have.
The select in D is OK since D has at least the same dependencies
as B.

So if we had a expr_is_subset_of(expr *e1, expr *e2)....

Roman - what do you think?

	Sam

