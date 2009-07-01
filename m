Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbZGAFAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbZGAFAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 01:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZGAFAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 01:00:31 -0400
Received: from ozlabs.org ([203.10.76.45]:58160 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbZGAFAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 01:00:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [PATCH] reduce export symbol CRC table size on 64-bit archs
Date: Wed, 1 Jul 2009 14:30:28 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: "Ingo Molnar" <mingo@elte.hu>, tony.luck@intel.com,
       "Thomas Gleixner" <tglx@linutronix.de>, hpa@zytor.com,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
References: <4A4A18780200007800008345@vpn.id2.novell.com>
In-Reply-To: <4A4A18780200007800008345@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907011430.29524.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 09:21:52 pm Jan Beulich wrote:
> Since these CRCs are really only 32-bit quantities, there's no need to
> store them in 64-bit slots. Since, however, gcc doesn't allow
> respective initializations, asm() constructs get used to create the CRC
> tables (and its for that reason that the patch only makes x86-64 and
> ia64 utilize that functionality, as I can't verify this doesn't break
> in some subtle way elsewhere).

Hmm, can we change the build system to just link this in as a normal table, 
rather than use linker tricks?

Then genksyms would just spit out a C file we could compile and link into final 
vmlinux.

Thanks,
Rusty.
