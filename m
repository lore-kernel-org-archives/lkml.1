Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbXKEXif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbXKEXif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 18:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbXKEXiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 18:38:25 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:54037 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbXKEXiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 18:38:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KqSKFUAO5H6N+v6oaggBPwWx+CD3EqPz5TfA25pxs8oAVg/rYK33ngmaTP+VMcYunlK+WcNcjB/6oQ5S/w+sq6VDxwsjzWuTlJl87QqeRA71Q0lxFOECgdlvjPGFRZxuVAa3dPeKXIaXVxmd42NYik1zLDE7JvpqZgjZZYR6Tvg=
Message-ID: <1865922a0711051538n61c5d979kac61652166da14e2@mail.gmail.com>
Date: Tue, 6 Nov 2007 01:38:22 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Cc: "Pavel Machek" <pavel@ucw.cz>, "Casey Schaufler" <casey@schaufler-ca.com>,
       akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Al Viro" <viro@ftp.linux.org.uk>
In-Reply-To: <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu>
	 <20071104122848.GC3921@ucw.cz> <20071105094007.GA19367@ubuntu>
	 <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/5/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Mon, 5 Nov 2007, Ahmed S. Darwish wrote:
>
> > On Sun, Nov 04, 2007 at 12:28:48PM +0000, Pavel Machek wrote:
> > >
> > > Can we avoid string parsers in the kernel?
> > >
> >
> > Ok, Could someone suggest a better idea please ?.
>
> I personally think string parsers are *much* better than the alternatives
> (which basically boil down to nasty binary interfaces)
>
> > I thought about packing the rules in a structure and sending
> > it over an ioctl() command. Is this applicable ?
>
> That's *MUCH* worse.
>
> Strings are nice. They aren't that complex, and as long as it's not a
> performance-critical area, there are basically no downsides.
>
> Binary structures and ioctl's are *much* worse. They are totally
> undebuggable with generic tools (think "echo" or "strace"), and they are a
> total nightmare to parse across architectures and pointer sizes.
>
> So the rule should be: always use strings if at all possible and relevant.
> If the data is fundamentally binary, it shouldn't be re-coded to ascii (no
> real advantage), but if the data is "stringish", and there aren't big
> performance issues, then keep it as strings.
>

Thanks a lot for such a kind advice. I'll keep that in my mind.

Regards,

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
