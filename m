Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbYB1Kfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbYB1Kfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 05:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755747AbYB1Kfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 05:35:43 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:14201 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753736AbYB1Kfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:35:42 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mark McLoughlin <markmc@redhat.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
In-Reply-To: <20080228094613.GC2987@elte.hu>
References: <1204187174-27143-1-git-send-email-ijc@hellion.org.uk>
	 <1204187174-27143-2-git-send-email-ijc@hellion.org.uk>
	 <1204191082.5446.13.camel@zakaz.uk.xensource.com>
	 <20080228094613.GC2987@elte.hu>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 10:35:23 +0000
Message-Id: <1204194923.5446.30.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.46.209.99
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 2/2] x86/xen: Disable DMI parsing in Xen kernel.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 10:46 +0100, Ingo Molnar wrote:
> * Ian Campbell <ijc@hellion.org.uk> wrote:
> 
> > Actually scratch this patchset -- its not sufficient. For example 
> > ddcprobe in userspace causes the exact same issue vs 0xa0000.
> > 
> > Looks like the only sane solution will be to mark regions between 
> > 640K-1M reserved early on in boot.
> 
> and as luck has it, such a patch from Alexander van Heukelum has been 
> put into x86.git#testing just yesterday.
> 
> So ... could you try x86.git#testing - does it work out of box? Is the 
> reservation early enough to prevent pagetables be allocated in weird 
> places?

That patch is 64 bit only and also I'm not sure what EBDA looks like to
a Xen domU (I expect it doesn't exist). I'll give it a go but I'm not
hopeful.

>  [or am i missing something - this is about the guest kernel 
> reserving th 640k..1M area, not the host kernel - right?]

Correct, the area between 640k and 1M is just normal memory for a Xen
guest and the memory map reflects that so page tables and other stuff
get allocated in regions which would be magic data structures on native.

Ian.
-- 
Ian Campbell

The woman you buy -- and she is the least expensive -- takes a great
deal of money.  The woman who gives herself takes all your time.
		-- Balzac

