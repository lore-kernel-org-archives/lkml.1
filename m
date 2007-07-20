Return-Path: <linux-kernel-owner+w=401wt.eu-S932429AbXGTR2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbXGTR2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbXGTR21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:28:27 -0400
Received: from ns2.suse.de ([195.135.220.15]:59633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757029AbXGTR20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:28:26 -0400
From: Andi Kleen <ak@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: build fix for x86_64...
Date: Fri, 20 Jul 2007 19:25:11 +0200
User-Agent: KMail/1.9.1
Cc: "Luck, Tony" <tony.luck@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andi Kleen <ak@novell.com>, Arthur Jones <arthur.jones@qlogic.com>,
       Vasily Tarasov <vtaras@openvz.org>, linux-kernel@vger.kernel.org,
       Jan Kara <jack@ucw.cz>, linux-arch@vger.kernel.org
References: <617E1C2C70743745A92448908E030B2A01FA46A9@scsmsx411.amr.corp.intel.com> <46A0EAC8.9020203@zytor.com>
In-Reply-To: <46A0EAC8.9020203@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707201925.12036.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 July 2007 19:03, H. Peter Anvin wrote:
> Luck, Tony wrote:
> > Which is better.  But if we unconditionally set this CONFIG variable,
> > then the code in fs/quota.c will have to read:
> >
> > #if defined(CONFIG_COMPAT) && defined(CONFIG_COMPAT_FOR_U64_ALIGNMENT)
> >
> > We can keep it simpler if the Kconfig file does the conditional for us:
> >
> > config COMPAT_FOR_U64_ALIGNMENT
> > 	def_bool y
> > 	depends on COMPAT
>
> No, that would be bad.  If compat_u64 is used to carry 32-bit ABIs

That doesn't help for any old interfaces, like the one here. For those
still ifdefs are needed. Interfaces that use compat_u64 just use
a normal #ifdef CONFIG_COMPAT.

Besides I have my doubts compat_u64 will be the solution
to these worries. We have hundreds of people adding various interfaces
to Linux and it's unlikely they all heard about it. So likely
these cases will occur again and again.

-Andi

