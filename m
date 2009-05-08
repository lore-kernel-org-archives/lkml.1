Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbZEHPAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbZEHPAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZEHPAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:00:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47255 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753206AbZEHPAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:00:07 -0400
Date: Fri, 8 May 2009 15:50:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH 06/16] xen: disable PAT
Message-ID: <20090508155031.4403f7e0@lxorguk.ukuu.org.uk>
In-Reply-To: <1241786311.16804.56.camel@zakaz.uk.xensource.com>
References: <1241730653-4688-1-git-send-email-jeremy@goop.org>
	<1241730653-4688-7-git-send-email-jeremy@goop.org>
	<20090508111432.GF11596@elte.hu>
	<1241786311.16804.56.camel@zakaz.uk.xensource.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Roughly speaking the kernel needs to cope with different values written
> to MSR_IA32_CR_PAT than the single hard coded value it would write
> itself if given the chance. Essentially _PAGE_CACHE_* need to become
> dynamic (or I guess we could change the native layout to match Xen's, I
> don't know why native differs from the initial state, I guess just to
> avoid using the PAT bit for some reason.

Because it is required for some processor variants due to errata. This is
also why the BIOS has them programmed as a mirror between 0-3 and 4-7.

I don't think changing Linux here is the right thing to do - if anything
Xen probably needs to change.

See Xeon errata P21.


Alan
