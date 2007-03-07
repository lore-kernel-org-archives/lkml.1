Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbXCHAzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbXCHAzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:55:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbXCHAzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:55:53 -0500
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:61050 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119AbXCHAzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:55:52 -0500
X-Greylist: delayed 4150 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2007 19:55:52 EST
Date: Thu, 8 Mar 2007 01:46:39 +0200
From: Sami Farin <7atbggg02@sneakemail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch v2] epoll use a single inode ...
Message-ID: <20070307234639.hkiaphqwtph6xg7q@m.safari.iki.fi>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703060917500.5963@woody.linux-foundation.org> <200703061828.00253.dada1@cosmosbay.com> <200703061910.13431.dada1@cosmosbay.com> <45EDCD11.8070000@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EDCD11.8070000@cosmosbay.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 21:20:33 +0100, Eric Dumazet wrote:
...
> I rewrote the reciprocal_div() for i386 so that one multiply is used.
> 
> static inline u32 reciprocal_divide(u32 A, u32 R)
> {
> #if __i386
>         unsigned int edx, eax;
>         asm("mul %2":"=a" (eax), "=d" (edx):"rm" (R), "0" (A));
               ^^^

mul does not work if R is memory operand.
mull should be used instead.

-- 
