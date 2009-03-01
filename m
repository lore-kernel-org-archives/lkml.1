Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbZCABsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbZCABsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 20:48:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbZCABsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 20:48:40 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38915 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbZCABsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 20:48:39 -0500
Date: Sun, 1 Mar 2009 03:07:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       mingo@elte.hu, nickpiggin@yahoo.com.au, sqazi@google.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Message-ID: <20090301020708.GI26292@one.firstfloor.org>
References: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain> <20090228092450.3ded2db5@infradead.org> <alpine.LFD.2.00.0902280935010.3111@localhost.localdomain> <20090228.160651.228301019.davem@davemloft.net> <20090301004003.GF26292@one.firstfloor.org> <49A9D6CA.30906@zytor.com> <20090228163811.48b1de72@infradead.org> <20090301014822.GG26292@one.firstfloor.org> <20090228173813.6d86c0ef@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228173813.6d86c0ef@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 05:38:13PM -0800, Arjan van de Ven wrote:
> On Sun, 1 Mar 2009 02:48:22 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > the entire point of using movntq and friends was to save half the
> > 
> > I thought the point was to not pollute caches? At least that is 
> > what I remember being told when I merged the patch.
> > 
> 
> the reason that movntq and co are faster is because you avoid the
> write-allocate behavior of the caches....

Not faster than rep ; movs which does similar magic anyways. Of course it being
magic it can vary a lot and is somewhat unpredictable.

Also in my experince movnt is not actually that much faster for small 
transfers (as in what the kernel mostly does) 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
