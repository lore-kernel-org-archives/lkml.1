Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbYHTXLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbYHTXLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 19:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbYHTXLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 19:11:37 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:20202 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbYHTXLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 19:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pXPFfPorNKP7x1nAuyhzFyjO8tvcbcQSiPUHNAxgKmJnC1f7j80eQhDLjcDLNzcX+D
         i+ZmhfOvZJDtiiXYzKO3mkDleeE+Cds20e9wV4j1CV3Goxv/8SN9eZLnEaRVc4Ok4O3L
         91ilwm11A3+fNgQcNlD79ceHccX5o2hgNqOKg=
Message-ID: <45a44e480808201611h57185209q9d738db054c3363b@mail.gmail.com>
Date: Wed, 20 Aug 2008 19:11:34 -0400
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] fbdefio: add set_page_dirty handler to deferred IO FB
Cc: "Ian Campbell" <ijc@hellion.org.uk>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org, npiggin@suse.de,
       a.p.zijlstra@chello.nl, hugh@veritas.com, hannes@saeurebad.de,
       jeremy@goop.org, kel@otaku42.de, armbru@redhat.com
In-Reply-To: <20080820125033.1cfcc2f1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219125765-31833-1-git-send-email-ijc@hellion.org.uk>
	 <20080818233824.5d219105.akpm@linux-foundation.org>
	 <1219220003.3996.29.camel@localhost.localdomain>
	 <20080820013736.ec64baae.akpm@linux-foundation.org>
	 <1219258673.3996.46.camel@localhost.localdomain>
	 <20080820123056.8f0c9d3f.akpm@linux-foundation.org>
	 <1219261254.3996.54.camel@localhost.localdomain>
	 <20080820125033.1cfcc2f1.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 3:50 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 20 Aug 2008 20:40:54 +0100
> Ian Campbell <ijc@hellion.org.uk> wrote:
>
>> On Wed, 2008-08-20 at 12:30 -0700, Andrew Morton wrote:
>> > On Wed, 20 Aug 2008 19:57:53 +0100 Ian Campbell <ijc@hellion.org.uk>
>> > wrote:
>> >     }
>> > > +#ifdef CONFIG_FB_DEFERRED_IO
>> > > + if (info->fbdefio)
>> > > +         fb_deferred_io_open(info, inode, file);
>> > > +#endif
>> >
>> > eww, hacky, but drivers/video/fbmem.c already got hacky:
>> >
>> > #ifdef CONFIG_FB_DEFERRED_IO
>> >         .fsync =        fb_deferred_io_fsync,
>> > #endif
>> >
>> > so it's not an original sin.
>>
>> That's what I figured.
>
> A better implementation would be to change the fb_ops.fb_open()
> arguments, or to add fb_ops.fb_open2() with the file*.
>
> Also, that .fsync thing should be done properly via a new fb_ops.fb_fsync().
>
> But neither are pressing issues and I guess can be left for when Jaya
> is feeling bored?


hehe, i haven't bene bored ever since i started playing with linux. :-)
