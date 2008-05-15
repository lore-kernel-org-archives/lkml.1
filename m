Return-Path: <linux-kernel-owner+w=401wt.eu-S1762910AbYEOX65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762910AbYEOX65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 19:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbYEOX6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 19:58:43 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48683 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754793AbYEOX6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 19:58:41 -0400
X-Sasl-enc: Hq8Mm302gbcP3JP+QECEkgtu2WbV6TarOjzE8pIzZqyX 1210895920
Date: Thu, 15 May 2008 20:58:38 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Theodore Tso <tytso@mit.edu>, Jeff Garzik <jeff@garzik.org>,
       Chris Peterson <cpeterso@cpeterso.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Rick Jones <rick.jones2@hp.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
	IRQF_SAMPLE_RANDOM
Message-ID: <20080515235838.GB23721@khazad-dum.debian.net>
References: <482C7E53.3050300@hp.com> <482C8184.2030906@garzik.org> <482C8550.5000909@intel.com> <482C8D4D.3040702@garzik.org> <a24804730805151301s3c6644d0hc2c78b8008fe035d@mail.gmail.com> <20080515214721.GP18825@mit.edu> <482CB1FB.7080807@garzik.org> <20080515222941.GB20976@khazad-dum.debian.net> <482CBCC6.6010905@garzik.org> <20080515233305.GS18825@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515233305.GS18825@mit.edu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Theodore Tso wrote:
> On Thu, May 15, 2008 at 06:44:22PM -0400, Jeff Garzik wrote:
> > I just sorta assumed a buffering, interrupt-driver TPM RNG driver would be 
> > better than doing it from userspace, but maybe that was a bad assumption to 
> > make on my part.  It should be quite doable to support TPM RNG entirely via 
> > userspace, at any rate.
> 
> If I recall correctly, you need access to a magic TPM key just to
> *talk* to the TPM.  Normally that key is stored in a file, and of

The TPM has some sort of idea of restricted operations.  It will depend
whether one can get random numbers as an anonymous party (and frankly, I
don't care for looking at the TCG docs right now to find out).

I certaily can ask the TPM "are you there?" even when it is disabled(!),
so I would not be too surprised to find out that, as long as it is
enabled, it will return random numbers to anyone.

But access to the TPM requires a control layer which must have excusive
access to the chip.  That layer would have to move into the kernel...
IMHO, it is just not worth even bothering with the idea, and just do it
all in userspace.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
