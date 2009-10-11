Return-Path: <linux-kernel-owner+w=401wt.eu-S1750930AbZJKSsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930AbZJKSsw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 14:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbZJKSsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 14:48:52 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58398 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791AbZJKSsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 14:48:51 -0400
X-Sasl-enc: Qqxetdoiz+sGCwhlE6tv+1QWwab1g4q9s66Rf/VLjJ2J 1255286867
Date: Sun, 11 Oct 2009 15:47:45 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linuxtronix.de, hpa@zytor.com
Subject: Re: [PATCH] x86: Relegate CONFIG_PAT to EMBEDDED
Message-ID: <20091011184745.GA18578@khazad-dum.debian.net>
References: <20091011084311.0ab3c3ea@infradead.org>
 <adaiqelj20l.fsf@cisco.com>
 <20091011103302.62bded41@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011103302.62bded41@infradead.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Oct 2009, Arjan van de Ven wrote:
> MTRR and PAT support (which got added to CPUs over 10 years ago) are no
> longer really optional in that more and more things are depending on PAT
> just working, including various drivers and newer versions of X.  (to not
> even speak of MTRR)

Please take a look at early_init_intel() in arch/x86/kernel/cpu/intel.c.
it disables PAT for what must amount to more than a *million* of
machines.  It certainly includes all Centrino laptops, for example(!).

FYI, these computers will be with us for at least 10 years, still.  I
still have users of Mobile Pentium II reporting bugs on thinkpad-acpi,
and I know of a *huge* number of active Pentium II and Pentium III
desktops in Brazil.  My 5-year-old ThinkPad T43 (Centrino, Pentium M)
cheerfully reports "PAT not supported by CPU" at boot if I decide to
waste memory by enabling CONFIG_X86_PAT.

So, unless that blacklist can be drastically reduced somehow, can we
*please* fix anything that depends on PAT "just working"?  Because as
far as the kernel is concerned right now, way too many machines can't
even dream of using PAT.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
