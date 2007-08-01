Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbXHAEH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbXHAEH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 00:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbXHAEHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 00:07:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54091 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174AbXHAEHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 00:07:52 -0400
Date: Tue, 31 Jul 2007 21:05:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
cc: Al Viro <viro@ftp.linux.org.uk>, Alexey Dobriyan <adobriyan@sw.ru>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       herbert@gondor.apana.org.au
Subject: Re: WARN_ON() which sometimes sucks
In-Reply-To: <18096.949.934194.648312@cargo.ozlabs.ibm.com>
Message-ID: <alpine.LFD.0.999.0707312101410.3582@woody.linux-foundation.org>
References: <20070731155527.GB7253@localhost.sw.ru> <20070731160248.GK21089@ftp.linux.org.uk>
 <18096.949.934194.648312@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Aug 2007, Paul Mackerras wrote:
>
> It will mean more code on architectures which have a
> conditional-trap-on-nonzero instruction, such as powerpc, since the
> compiler will generate instructions to evaluate !!x.  But I don't see
> any reason why ret_warn_on couldn't be a long.

Umm. The WARN_ON() might actually get a "long long" value for all we know. 
Ie it's perfectly possible that the WARN_ON might look like

	/* Must not have high bits on */
	WARN_ON(offset & 0xffffffff00000000);

which on a 32-bit pcc would apparently do the wrong thing entirely as it 
stands now. No?

I think I'll commit the !!(x) version, and you guys can try to figure out 
what the right thing is long-term. For all I know, the proper solution is 
to just revert the whole mess, and *not* make WARN_ON() return a value at 
all, since that seems to be the fundamental mistake here.

			Linus
