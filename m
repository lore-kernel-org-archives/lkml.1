Return-Path: <linux-kernel-owner+w=401wt.eu-S1758749AbXIRUNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749AbXIRUNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbXIRUM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:12:59 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:29880 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbXIRUM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:12:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h/xj5tsRmYcxXHzsHnW3RAHIRpJCXfca1E7rzhalbXprehd2sjdUzYWmKPwB9eXEFVRLPiXfTnkVuxr+6taeHjUmZ+xJ+FSKca1pQ90mGY6NHs4gN1l8HLJqusdQFv2SZcg/YKevzh2GltJPsNmZZk5adpJAo19bWb1KAKPmmeg=
Message-ID: <43e72e890709181312sf2b421cn49be3389b3786a2a@mail.gmail.com>
Date: Tue, 18 Sep 2007 16:12:56 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>
	 <20070918113401.6a8a737f@the-village.bc.nu>
	 <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com>
	 <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>
	 <43e72e890709181207j7c85dc29sb355a9f5a4207411@mail.gmail.com>
	 <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 18 Sep 2007, Luis R. Rodriguez wrote:
> >
> > ACK -- driver developers use this just to save themselves a few lines
> > from calling pci_resource_start() and friends. How about having an
> > inline which does what pci_iomap() does except it doesn't call
> > ioport_map() ? I am just not sure where this would go..
>
> I'm not understanding what the problem is?
>
> Why don't these people just use "ioread*()/iowrite*()"?
>
> In other words, the whole point of *not* using "read*/write*()" is that
> you get a whole slew of much nicer interfaces.
>
> So can people explain this fundamental issue? Why do people insist on
> using the old interfaces (and matching them with the new setup)?

An extra branch is created on MMIO-only devices on read/writes on the
IO_COND macro using this interface -- or is this optimized out?

  Luis
