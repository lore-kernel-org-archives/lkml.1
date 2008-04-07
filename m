Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbYDGWzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbYDGWzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYDGWza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:55:30 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:40722 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYDGWz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:55:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nceowqv+DsPFsuolHqEAPibCjyF3G6XEKtlqLIh9LCH1MCMkaHJuxsBks5GPhW9ke7kRjldeykdAewbW1FPs+SVExKktE7a3BccYlpqLPWSjUCBR+HSBD2UBGJfYris+rkV1EYkd5RlSnkryK86D+N/sF/RHeoDcd4Pq+BWySww=
Message-ID: <2c0942db0804071555w2dc2e43fw7cce64d4a5ba004@mail.gmail.com>
Date: Mon, 7 Apr 2008 15:55:27 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Tilman Schmidt" <tilman@imap.cc>
Subject: Re: [2.6.25-rc6] possible regression: X server dying
Cc: "Dave Airlie" <airlied@gmail.com>, linux-kernel@vger.kernel.org,
       pavel@ucw.cz
In-Reply-To: <47FA9EC2.6030801@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47E82D68.5070305@imap.cc>
	 <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com>
	 <47E83D14.8070800@imap.cc>
	 <21d7e9970803241753q433e7545pdd00eae189846a8@mail.gmail.com>
	 <21d7e9970803302153s314d48d3o7120a56092eeaede@mail.gmail.com>
	 <47F1FA3F.3010206@imap.cc> <47FA9EC2.6030801@imap.cc>
X-Google-Sender-Auth: 47f25ac820a16d81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2008 at 3:22 PM, Tilman Schmidt <tilman@imap.cc> wrote:
> This is still quite elusive. It only happens once every couple of days,
>  and the only thing that seems to be clear is that it's triggered by a GL
>  screensaver. So if it's ok I'll continue sharing X crash backtraces
>  while I go on groping for a lead. Here's my next one, this time with
>  kernel 2.6.25-rc8:
>
>
>  0: /usr/bin/X(xf86SigHandler+0x81) [0x80e6d81]
>  1: [0xb7f22400]
>  2:
>  /usr/lib/xorg/modules//extensions/libGLcore.so(_mesa_set_enable+0x1343)
>  [0xb50aa673]
>  3: /usr/lib/xorg/modules//extensions/libGLcore.so(_mesa_Disable+0x5a)
>  [0xb50abc1a]
>  4: /usr/lib/xorg/modules//extensions/libglx.so [0xb7ba8b98]
>  5: /usr/lib/xorg/modules//extensions/libglx.so(DoRender+0xdd) [0xb7ba145d]
>  6: /usr/lib/xorg/modules//extensions/libglx.so [0xb7ba157c]
>  7: /usr/lib/xorg/modules//extensions/libglx.so [0xb7ba5a6d]
>  8: /usr/bin/X [0x815809e]
>
> 9: /usr/bin/X(Dispatch+0x1af) [0x808f68f]
>  10: /usr/bin/X(main+0x47e) [0x807717e]
>  11: /lib/libc.so.6(__libc_start_main+0xe0) [0xb7cb6fe0]
>  12: /usr/bin/X(FontFileCompleteXLFD+0x1e5) [0x8076501]
>
>  As for Pavel's suggestion of disabling heap randomization, given the
>  current crash rate I'd have to try that for several weeks before I could
>  be reasonably sure that it helped. I think it'll be more useful if I go
>  on looking for a way to reproduce the crash more reliably. Perhaps I
>  should start playing some GL based games. :-)

If you think it's one of the screensavers but don't know which one,
then open up a bash shell and do a

for i in /usr/lib/xscreensaver/*; do echo $i; $i ; done

hitting control-c to break out of the screensaver when you think it's
been cleared of any wrongdoing. They'll default to rendering in a
window rather than the root window, but perhaps that'll be good enough
to hit the bug (it also lets you see the name of the screensaver it
just ran).
