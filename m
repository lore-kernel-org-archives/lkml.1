Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968082Ab0B0Jdu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 04:33:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:28199 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968054Ab0B0Jds convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 04:33:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=T5t6OtOVaXGoOyAjslqv5q+6D9JEqkssxytcHHU2047806qpjXbdYwEAX6WBWY9W4B
         W8pLmEqdW3jKb/Amx787nOERLOuvyzPjXuH+OhgNlWBDLOIMdVTN9FLWelduFVr//pyX
         k7XbXUlnzXomCAJqUE1mVAwdUkgK2ClO2Abqs=
MIME-Version: 1.0
In-Reply-To: <20100226190100.GQ10145@sci.fi>
References: <1266761422-2921-1-git-send-email-zajec5@gmail.com>
	 <b170af451002260238p29c7db97nd50154bf7288ef42@mail.gmail.com>
	 <20100226081418.5902446f.akpm@linux-foundation.org>
	 <b170af451002260933i6a7a5e1el619f8e71c3ae0bc8@mail.gmail.com>
	 <20100226190100.GQ10145@sci.fi>
Date: Sat, 27 Feb 2010 10:33:46 +0100
Message-ID: <b170af451002270133v6c44a6bcnf5751a6338c61a63@mail.gmail.com>
Subject: Re: [PATCH][RFC] time: add wait_interruptible_timeout macro to sleep 
	(w. timeout) until wake_up
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 26 lutego 2010 20:01 użytkownik Ville Syrjälä <syrjala@sci.fi> napisał:
> Disabling the condition check doesn't make sense.
>
> You could use a completion.
>
> init_completion(vbl_irq);
> enable_vbl_irq();
> wait_for_completion(vbl_irq);
> disable_vbl_irq();
> and call complete(vbl_irq) in the interrupt handler.
>
> The same would of course work with just some flag or counter
> and a wait queue.

Ouch, I can see it gone bad already.

Firstly I simply just wanted to avoid condition in wait_event_*. It
looked unnecessary as I got interrupts (signals). So I started playing
with other solutions (like my wait_interruptible_timeout where I had
not full understanding of waking up) and finally started analyzing
over-complex things like completions.

I'll just use some one more variable and some more basic solution.

Thanks for help and sorry for taking your time. I hope to provide at
least some of you dynamic radeon PM in return :)

-- 
Rafał
