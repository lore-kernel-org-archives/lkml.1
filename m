Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbYDMT3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbYDMT3k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYDMT3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:29:33 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:4821 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752392AbYDMT3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:29:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mV+43hkfgNdeKwDNZp/Dldx8VFKK6wSbRoYLyZqdRMmoQmd/EAn4KRTZEIvdqBx4OayssOvBraLtiikUiheMbOqd0AxklbWj5DB7qZTnb0VW7GlQWixzU453nd/2jyNGt5JGHmS13v2JFOdMUJ/dMQozw0Ww1t0RNkhf+TPM2nA=
Message-ID: <86802c440804131229q7d68091bpa18ac32d379f0ef9@mail.gmail.com>
Date: Sun, 13 Apr 2008 12:29:30 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [rfc] hw resource debugging checks
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
In-Reply-To: <20080413182910.GB8641@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804102159.14563.rjw@sisk.pl> <20080410203800.GA14560@elte.hu>
	 <200804110028.22290.rjw@sisk.pl> <200804112126.29455.rjw@sisk.pl>
	 <20080413075845.GJ20332@elte.hu> <87d4ouw0u9.fsf@basil.nowhere.org>
	 <86802c440804131119m1c43497bg1864ce9751438e85@mail.gmail.com>
	 <20080413182910.GB8641@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 11:29 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > even I could talk to BIOS
>  > engineers everyday and tell them how to fix the problem in BIOS,  some
>  > still can not be fixed because of the legacy BIOS framework or big
>  > mess.
>
>  ... so you opt to create the big mess in the kernel. Great.
>
>  And it does not even fixes a real problem, but getting
>  mmconfig or the numa bus discovery to work is not really a too serious
>  issue anyways. At best it is the icing on the cake to enable
>  some relatively obscure functionality and be a little more
>  efficient, but nothing really fundamental.
>
>  But for those things just expecting a working modern BIOS is quite
>  reasonable.

it does fix real problem. when big system with several HT links, and
every link some pcie slots.
you fully load pci-e cards (with pci bridge). BIOS will stop assign
io/mmio resource to left device if it run out of io port range.
(though it is supposed to go on to allocate mmio to left devices) (
modern pcie device only need mmio with drivers)

With pre set range allocation in NB pci conf, kernel could allocate
the resource in every peer root bus ranges.
(the code for assign resource to device that is not assigned resource
by BIOS --- already in kernel)

YH
