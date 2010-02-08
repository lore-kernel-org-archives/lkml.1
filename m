Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab0BHAJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 19:09:23 -0500
Received: from ozlabs.org ([203.10.76.45]:60384 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946Ab0BHAJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 19:09:22 -0500
Date: Mon, 8 Feb 2010 11:04:35 +1100
From: Anton Blanchard <anton@samba.org>
To: Michael Neuling <mikey@neuling.org>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Serge Hallyn <serue@us.ibm.com>, WANG Cong <xiyou.wangcong@gmail.com>,
       Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
       miltonm@bga.com, aeb@cwi.nl
Subject: Re: Stack size protection broken on ppc64
Message-ID: <20100208000435.GJ32246@kryten>
References: <3984.1265416993@neuling.org>
 <20100206042038.GB32246@kryten>
 <10125.1265451732@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10125.1265451732@neuling.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> Cool, thanks.  The following is based on this and fixes the problem for
> me on PPC64 ie. the !CONFIG_STACK_GROWSUP case. 

Thanks! Seeing the original setting of EXTRA_STACK_VM_PAGES is more or
less random, I wonder if we should round EXTRA_STACK_VM_SIZE up to 128kB
(or even down to 64kB) so it operates better with > 4kB pages.

But in the end its probably of little use for the default OVERCOMMIT_GUESS
setting, so the main thing is we dont terminate processes incorrectly.

Acked-by: Anton Blanchard <anton@samba.org>

Anton
