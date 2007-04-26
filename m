Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbXDZLMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbXDZLMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 07:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbXDZLMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 07:12:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:44340 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbXDZLMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 07:12:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iGE14ZAOycEel825WZsmwBMo6jyI0vuHgQHoBnn9kBV7pWaw4Fwdy4f3CRsQ6oyGc21v26B6HXv/GZjN0+gJ+RwGiCH62StI/0X+6+nNibLprlaonYAKmp7EjnYt4tp8UO5H4+lcZgnEA99Bx8XLDcJOPhuwjoszPPjXXkl9d4s=
Message-ID: <84144f020704260412t56b6db08h9d0d2961158e33fd@mail.gmail.com>
Date: Thu, 26 Apr 2007 14:12:50 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Cc: "Dumitru Ciobarcianu" <Dumitru.Ciobarcianu@ines.ro>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Christian Hesse" <mail@earthworm.de>, "Nick Piggin" <npiggin@suse.de>,
       "Mike Galbraith" <efault@gmx.de>, linux-kernel@vger.kernel.org,
       "Con Kolivas" <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@infradead.org>, rjw@sisk.pl
In-Reply-To: <20070425081051.GA7221@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070418220228.GA14536@elte.hu> <20070419070437.GA25211@elte.hu>
	 <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
	 <20070425064137.GA25247@elte.hu> <20070425072904.GB6866@ucw.cz>
	 <1177487338.17755.46.camel@DustPuppy.LNX.RO>
	 <20070425081051.GA7221@ucw.cz>
X-Google-Sender-Auth: cbf1ee002fee9a5f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/07, Pavel Machek <pavel@ucw.cz> wrote:
> > Please stop using FUD.
> > Graphical progress it's not in the kernel, even with suspend2.
>
> It was ascii-art, but still 'graphical', last time I checked.

Suspend2 talks to an userspace client via netlink. While I find the
name of the message ("redraw UI") rather appaling, there's nothing
wrong in principle that userspace starts the suspend process and the
kernel keeps feeding back progress information ("I froze all processes
now") so it can display a graphical progress bar.

The real question here is what to do with compression and encryption.
However, if you settle for one compression algorithm (such as LZF in
the case of suspend2) and use the _existing_ in-kernel crypto API for
encryption, suddenly the benefits of userspace suspend are not clear.

As you and Rafael seem to be mostly interested in uswsusp, why don't
we replace the old in-kernel implementation with suspend2?

                                         Pekka
