Return-Path: <linux-kernel-owner+w=401wt.eu-S934937AbXHAPTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934937AbXHAPTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933695AbXHAPTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:19:11 -0400
Received: from flvpn.ccur.com ([66.10.65.2]:57300 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932926AbXHAPTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:19:09 -0400
Date: Wed, 1 Aug 2007 11:17:15 -0400
From: Joe Korty <joe.korty@ccur.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Alexey Dobriyan <adobriyan@sw.ru>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       herbert@gondor.apana.org.au
Subject: Re: WARN_ON() which sometimes sucks
Message-ID: <20070801151715.GA22431@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20070731155527.GB7253@localhost.sw.ru> <20070731160248.GK21089@ftp.linux.org.uk> <18096.949.934194.648312@cargo.ozlabs.ibm.com> <alpine.LFD.0.999.0707312101410.3582@woody.linux-foundation.org> <18096.2592.877510.221163@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18096.2592.877510.221163@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 02:20:48PM +1000, Paul Mackerras wrote:
> Linus Torvalds writes:
> 
> > Umm. The WARN_ON() might actually get a "long long" value for all we know. 
> > Ie it's perfectly possible that the WARN_ON might look like
> > 
> > 	/* Must not have high bits on */
> > 	WARN_ON(offset & 0xffffffff00000000);
> > 
> > which on a 32-bit pcc would apparently do the wrong thing entirely as it 
> > stands now. No?
> 
> Actually, because of the typeof in the powerpc WARN_ON, I think it
> would fail to build since we'd be passing a long long value to an
> inline asm, or at least I hope it would fail to build. :)


Turning the condition into an integer should work ...

	#define NEW_WARN_ON(x) OLD_WARN_ON(!!(x))

Regards,
Joe

