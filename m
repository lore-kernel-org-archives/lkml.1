Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbZDVSx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbZDVSx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 14:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZDVSxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 14:53:49 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:62760 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZDVSxt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 14:53:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xOfskEDCeJi4GIfXjhy/hODQwCJefVct9eU1fEhZfUF+Ti41B8aAssK/3PNOsKdpu4
         248NMF5VlPd9W6RmOjCYvID5M3RdYcgeKyJoG5j+J5+ziDtlVeg3oOOtcvrS6HVzmp+J
         hlTMuLUteBY/wWgnrtqvKGMbqqcmEaH5jHnTY=
MIME-Version: 1.0
In-Reply-To: <49EF4E14.6090708@ti.com>
References: <49ECE615.2010800@ti.com> <20090421063523.GA8020@elte.hu>
	 <1240345936.6080.6.camel@localhost> <49EE54B4.9020700@ti.com>
	 <1240358715.6080.42.camel@localhost> <49EE89EF.1000707@ti.com>
	 <49EF37FC.8020909@nortel.com> <49EF4E14.6090708@ti.com>
Date: Wed, 22 Apr 2009 20:53:44 +0200
X-Google-Sender-Auth: 4acef0d35ae76395
Message-ID: <10f740e80904221153g5cb23756p2f71abe44f4273f3@mail.gmail.com>
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep for 
	more than 2.15 seconds
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Chris Friesen <cfriesen@nortel.com>, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 19:04, Jon Hunter <jon-hunter@ti.com> wrote:
> Chris Friesen wrote:
>>
>> Isn't "long long" guaranteed to be 64-bit on all linux systems?
>
> If long long is guaranteed to be 64-bits this is the way to go. Looks like
> there was some previous discussion on making u64 always a long long, but I
> am not sure that this happened [1]. So may be this does confirm this?
>
>> Unless the width is critical, I'd prefer to stay away from u64 until it
>> gets unified between architectures.  I recently ran into a problem
>> printk-ing a "u64" value because it was a different type on ppc64 than
>> x86-64.
>
> It is not critical but maybe more ideal, as it would be nice to be explicit
> that this variable is intended to be 64bits. In fact the issue you saw with
> the printk is one of the reasons that I previously mentioned of why I had
> opted to stay with long long. I also found that this issue was discussed in
> the thread I mentioned above [1]. Seems like a common problem.
>
> The alternative is to use u64 and make sure that all printks cast the
> variable to long long where necessary. However, this is not clean and you do
> run the risk of a new print being added that does not take this into account
> and breaks the code for some architectures. So I wished to avoid this.

That's why recently, u64 became `unsigned long long' on ppc64. So please stay
away from the casts.

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
