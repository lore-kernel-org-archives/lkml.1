Return-Path: <linux-kernel-owner+w=401wt.eu-S1752112AbZIVTro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbZIVTro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZIVTrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:47:43 -0400
Received: from claw.goop.org ([74.207.240.146]:45021 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbZIVTrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:47:43 -0400
Message-ID: <4AB929DC.60002@goop.org>
Date: Tue, 22 Sep 2009 12:47:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Paravirtualization on VMware's Platform [VMI].
References: <1253233028.19731.63.camel@ank32.eng.vmware.com>	 <20090919224430.GB9567@kroah.com>	 <1253419185.3253.21.camel@ank32.eng.vmware.com>	 <20090920074247.GA5733@elte.hu> <1253647845.10565.20.camel@ank32.eng.vmware.com>
In-Reply-To: <1253647845.10565.20.camel@ank32.eng.vmware.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/09 12:30, Alok Kataria wrote:
> We can certainly look at removing some paravirt-hooks which are only
> used by VMI. Not sure if there are any but will take a look when we
> actually remove VMI.
>   

There are a couple:

    * pte_update_defer
    * alloc_pmd_clone

lguest appears to still use pte_update(), but I suspect its two
callsites could be recast in the form of other existing pvops.

    J
