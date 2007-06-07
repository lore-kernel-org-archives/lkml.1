Return-Path: <linux-kernel-owner+w=401wt.eu-S1762791AbXFGOjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762791AbXFGOjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbXFGOji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:39:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:2774 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbXFGOjh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:39:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vr6XaFO98vpVwMhc/WUFrrvbYaRI7UaBv3q0RTHUEY7jyYglt1PAz5QR9xnANFmJ/8gsAyr+2B1APaMJvOyFotlhkZ42vaCBl6DvwLHvRi06ZvEriF6L3fdIc0WCMtsraMqAJ3p3FIxtvrWn0i4D7SFBhrgkXLilAvZhKDdC0xM=
Message-ID: <9a8748490706070739l14dbebb0s87d6cfe6bd93b164@mail.gmail.com>
Date: Thu, 7 Jun 2007 16:39:35 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Cc: "Andy Whitcroft" <apw@shadowen.org>, "Andrew Morton" <akpm@osdl.org>,
       "Randy Dunlap" <rdunlap@xenotime.net>,
       "Joel Schopp" <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
	 <9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com>
	 <Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Jun 6 2007 11:05, Jesper Juhl wrote:
> >
> > - Source files should be 7bit ASCII
>
> Nah. Think of....
>
> MODULE_AUTHOR("J. Ørsted <jorsted@foobar.com>");
>
That's true. I wrote that comment shortly after reading
http://lkml.org/lkml/2007/6/4/448 , but you are right, 7bit ASCII can
be too limiting at times... Hmmm...

> > - Maybe warn about usage of float/double in source files?
>
> Generally yes, maybe, but see arch/i386/kernel/cpu/bugs.c,
> arch/i386/math-emu/. Generally there is nothing to it. I think the
> feature to allow the kernel to use [i387] FP without manually
> saving/restoring the FP stack has been added some time ago.
>
I know there are places where floats and doubles can be used safely,
but for those rare occasions wouldn't it make sense to have the script
warn and require the submitter to justify the use?  After all, the
general rule is to not use floating point in the kernel, so such a
patch is suspicious.

> > - 'return' is not a function, so warn about patches that think it is
> > and use 'return(expr);' (this one is tricky since 'return (expr);' can
> > be OK in some cases.
>
> Now, if we could detect superfluous parentheses and branches,
> that'd be cool ;-) there are too many if ((a < 5) || (b > 6)) around.
>
Yeah wouldn't it be cool :-)  It might require a bit too much perl
magic to actually implement something sane, but I just threw every
idea that came into my mind into the mail, assuming Andy could sort
out the ones that were a little too crazy ;)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
