Return-Path: <linux-kernel-owner+w=401wt.eu-S965860AbXCSPQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965860AbXCSPQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965862AbXCSPQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:16:26 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:51324 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965860AbXCSPQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:16:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B7RPLJK2XHKVgZS9GywNVEIP749P9U9ZfoafxNvkIa6XFMb0w1pp8eNrEVyyHZNGUZGl9CXaQRPHtXzEl0v4xmMej7I0Y6yFmjvvtfrBtzh4qiuAYmiZ9a8R7d0Li11hgjywRXULDYcAdZPKANNx//fSCXPGzT9XNMeWPYwJoOM=
Message-ID: <9a8748490703190816w2f4bc4b5je8d5c17d232f15c9@mail.gmail.com>
Date: Mon, 19 Mar 2007 16:16:24 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH][5/5][resend] floppy.c: Fix device_create_file() warning
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Trent Waddington" <trent.waddington@gmail.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <200703191613.04223.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703191611.13849.jesper.juhl@gmail.com>
	 <200703191613.04223.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/07, Andi Kleen <ak@suse.de> wrote:
>
> >
> > -             device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
> > +             err = device_create_file(&floppy_device[drive].dev, &dev_attr_cmos);
> > +             if (err)
> > +                     printk(KERN_WARNING "Unable to create sysfs attribute "
> > +                             "file for floppy device: %s\n",
> > +                             floppy_device[drive].name);
>
> That change looks pretty useless. Either the error should be handled correctly
> by bailing out or the warn_unused_results should be dropped.
>
At least letting the user know that something failed is better than
the current situation of just failing silently I'd say.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
