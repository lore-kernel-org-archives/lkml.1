Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbZDUTKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbZDUTKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZDUTJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:09:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48035 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZDUTJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:09:51 -0400
Message-ID: <49EE19E0.8040405@zytor.com>
Date: Tue, 21 Apr 2009 12:09:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Hitoshi Mitake <h.mitake@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
References: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain>	<adaab6c1h7c.fsf@cisco.com> <20090419214602.GA21527@elte.hu>	<adaws9gywkd.fsf@cisco.com> <49EBCDC0.1020001@zytor.com>	<20090420105304.GC6670@elte.hu>	<a6b9f31a0904200747x7e28a4e3if0be4fc0d87241c9@mail.gmail.com>	<20090420160332.GB9689@elte.hu>	<a6b9f31a0904210133m29e68580w1fb7a8e6159b65d6@mail.gmail.com>	<49EDE9E9.8090905@zytor.com> <adamyaavst5.fsf@cisco.com>	<49EE0013.6010008@zytor.com> <adaab69x6nd.fsf@cisco.com>
In-Reply-To: <adaab69x6nd.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > > However I worry that this just leaves driver authors too much rope.
>  > > Choosing readq_atomic() vs. readq() is just one more thing to get wrong.
> 
>  > ... as is having each driver implementing their own substitutes.
> 
> Yes, I agree with that.  However at least status quo ante (readq/writeq
> 64-bit only) means that driver authors who use readq/writeq are forced
> (by a compile error) to spend a little thought on what 32-bit fallback
> they should use.
> 
> I guess one possibility is to make readq/writeq the atomic version, and
> add readq_nonatomic()/writeq_nonatomic() for 32-bit architectures.  Then
> it's much more opt-in -- but then that makes the (perhaps) more common
> case look a bit uglier.
> 

Do you really expect driver authors to type writeq_nonatomic() for every 
register reference?

I think an #include at the top is one thing, but something that 
heavyweight for each call site really isn't going to fly.

	-hpa

