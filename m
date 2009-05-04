Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbZEDPOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbZEDPOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbZEDPNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:13:50 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:41938 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbZEDPNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:13:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fCKb6k7Z8wifzhlC0bWmwDFGxZdmfg8gmXkZQKtBEvRypY1Gv/KVwKSEWO0HnKwJvE
         w9N7iWmT1U2g6yYHoy3KrRzaNiyAMQJd0EjZ1cZpA4cIwBz1PTsPx/GVY2ZsTSd6dAuR
         KQ0NR6k9NNGyzJQ0qTEmVBhlH9ZmigwdqSgjQ=
MIME-Version: 1.0
In-Reply-To: <20090504145348.GA10545@kroah.com>
References: <3a3680030905030900x672af596mc2ebc3c38f119c92@mail.gmail.com>
	 <3a3680030905032038h40cd75bdrbee839117e5a4d55@mail.gmail.com>
	 <200905040854.03329.oliver@neukum.org>
	 <200905040002.38304.david-b@pacbell.net>
	 <84144f020905040041n721336a0t4c0f4c25eb272abf@mail.gmail.com>
	 <20090504145348.GA10545@kroah.com>
Date: Mon, 4 May 2009 23:13:49 +0800
Message-ID: <3a3680030905040813x3e372f64kf73e33cdab45a31b@mail.gmail.com>
Subject: Re: [PATCH] usb: use memdup_user()
From: Li Hong <lihong.hi@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       David Brownell <david-b@pacbell.net>, Oliver Neukum <oliver@neukum.org>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/4 Greg KH <greg@kroah.com>:
> On Mon, May 04, 2009 at 10:41:51AM +0300, Pekka Enberg wrote:
>> Hi!
>>
>> On Sunday 03 May 2009, Oliver Neukum wrote:
>> >> No. To make it plain. To me any use of memdup_user() in USB code
>> >> is a bad idea. I don't want to have to think about a new primitive.
>>
>> On Mon, May 4, 2009 at 10:02 AM, David Brownell <david-b@pacbell.net> wrote:
>> > Unless it's incorrect to use that, I have to say that it
>> > makes more sense to use that utility than recreate it by
>> > open-coding...
>>
>> Yup, and I don't really see how anyone can avoid "thinking about a new
>> primitive" anyway. We have it in the kernel now and surely it will
>> appear under drivers/usb/ sooner or later...
>
> Well, how about passing the GPF flags down to memdup_user() so that we
> can use it in the usb subsystem, and Oliver's complaint will be resolve?
>
> thanks,
>
> greg k-h
>

No, the debate is not here. As the comment in memdup_user() says:

        /*
         * Always use GFP_KERNEL, since copy_from_user() can sleep and
         * cause pagefault, which makes it pointless to use GFP_NOFS
         * or GFP_ATOMIC.
         */

So it is pointless to add a GFP flag to memdup_user().

I guess what Oliver insists is that the involvement of memdup_user() erases
the explicit call of kmalloc(). However, doesn't every function wrap
some details?

Regards,
Hong
