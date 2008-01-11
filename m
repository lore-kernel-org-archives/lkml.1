Return-Path: <linux-kernel-owner+w=401wt.eu-S1761969AbYAKU1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761969AbYAKU1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 15:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbYAKU1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 15:27:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54548 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762414AbYAKU1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 15:27:39 -0500
Date: Fri, 11 Jan 2008 12:27:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
In-Reply-To: <20080111201716.GO18741@parisc-linux.org>
Message-ID: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>
References: <20071225032605.29147200@laptopd505.fenrus.org> <20080111190229.GB10112@kroah.com> <20080111192820.GM18741@parisc-linux.org> <20080111114002.3e59d1ad@laptopd505.fenrus.org> <20080111194524.GA17170@suse.de> <20080111194931.GN18741@parisc-linux.org>
 <alpine.LFD.1.00.0801111156230.3148@woody.linux-foundation.org> <20080111201716.GO18741@parisc-linux.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Jan 2008, Matthew Wilcox wrote:
> 
> Ivan's patch doesn't start enabling MMCONFIG in more places than we
> currently do.  It makes us use conf1 accesses for all accesses below
> 256 bytes.  That fixes all known problems to date.

.. and I agree with that patch. But there will be people who try to access 
extended space by mistake, and they'll have a hard-locked machine or 
something.

> > Tell me what *other* armor plating you could have that actually works?
> 
> The armour plating that already exists -- pci=nommconf.

No. It needs to be automatic, OR THE OTHER WAY AROUND.

Ie we disable the unsafe feature on purpose, and then force people who 
access it to do so *consciously*.

Extended config space is different, for chissake! It's not even like it's 
just a bigger normal config space where normal config accesses just 
overflow into it. It really does have different rules etc.

			Linus
