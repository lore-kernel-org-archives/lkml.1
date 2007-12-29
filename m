Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbXL2I1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbXL2I1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 03:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbXL2I1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 03:27:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56520
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752118AbXL2I1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 03:27:09 -0500
Date: Sat, 29 Dec 2007 00:27:08 -0800 (PST)
Message-Id: <20071229.002708.30708773.davem@davemloft.net>
To: bunk@kernel.org
Cc: errandir_news@mph.eclipse.co.uk, m.kozlowski@tuxland.pl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1: some section mismatches on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071229.001411.210630819.davem@davemloft.net>
References: <20071226.190504.20990618.davem@davemloft.net>
	<20071228232255.GB9105@does.not.exist>
	<20071229.001411.210630819.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sat, 29 Dec 2007 00:14:11 -0800 (PST)

> You can't do that, the FOO_CONSOLE config options depend upon
> FOO=y.
> 
> That's why I'm not worried about this issue and it's not critical at
> all.

Adrian, if you're interested in tackling this "fun" problem,
have a look at add_preferred_console() and find a way to make
that not marked __init. (it's called by sunserial_console_match)

That's what causes this dependency chain of __init problems for the
Sun serial console drivers.

It's problematic, furthermore, because even if one could call
add_preferred_console() from a module properly, it doesn't have the
desired effect of changing init's stdin/stdout/stderr
