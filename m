Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbZERGac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbZERGac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 02:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbZERGaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 02:30:15 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:41981 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbZERGaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 02:30:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=oroPydlnHFRv94/GK78H+CFFnnRpVc9imS3A6AFJHWnJBpEnbTxV8UD6VZsv1D3uN9
         CcN0dLhMzB9ypcIgPMCXG/f5ImOPf8DZpM9BzZnIcO1TLnmkzX6I2QvEwPagc/jWYl8N
         4W+Z3qMg+ifYPxPjrKjA9Bwc4zqaFz+pICfG0=
Date: Mon, 18 May 2009 08:30:07 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Subject: Re: 2.9.29.2: ide-tape: panic when probing device at boot
Message-ID: <20090518063007.GA7818@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
References: <20090509161801.GB5749@liondog.tnic> <200905180532.n4I5Wxa1031243@turbo.physics.adelaide.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200905180532.n4I5Wxa1031243@turbo.physics.adelaide.edu.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 18, 2009 at 03:02:59PM +0930, Jonathan Woithe wrote:
> > On Sat, May 09, 2009 at 05:57:49PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > > 
> > > [ cc:ing linux-ide and knowledgeable people ]
> > > 
> > > Borislav/Tejun:
> > > Is the 2.6.29 problem the same thing that was fixed recently?
> > 
> > I'll let Tejun answer that one since I don't get an oops. However, now
> > that I have an ide-tape hardware here, I do get something DMA-related
> > failing during boot ...
> > :
> > and more specifically the bad DMA info in identify block thing above. I
> > haven't looked into it yet but its next on my TODO.
> 
> Cool.
> 
> > > Should I just push commit 1e75540ec5202cae63cd238c86bd880e3d496546
> > > ("ide-tape: remove back-to-back REQUEST_SENSE detection") to Linus
> > > or there is more needed to bring ide-tape to the world of living?
> >
> > The oops will probably fixed the above commit.  I don't have much idea
> > about the DMA problem on 2.6.24 tho.  But even with the above commit
> > fixed, I doubt it would work.  The buffer allocation code is broken
> > and reliably triggered OOM on my test machine.  While trying to locate
> > the bug, I realized the complex code didn't do much good to begin with
> > and just stripped it down, so I didn't actually tracked down the
> > actual bug && the patch to simplify buffer management is way too large
> > for 2.6.29, so unless someone is willing to hunt down the bug just for
> > 2.6.29, we're kind of stuck.  :-(
> 
> So I take it that 2.6.30 (or one of the RCs) is worth trying (at least in so
> far as preventing the oops on boot)?

You could try 30-rc6 which runs pretty stable on my machines. It has the
patch mentioned above in it. At least one user confirmed that it fixes
ide-tape in his case. In case you still catch any OOPSes/warnings etc
please send me the whole dmesg output along with how you trigger them.

> > ... and I'm afraid we'll have to do some serious bugfixing since this
> > driver is behaving really funny :). Stay tuned, I'm on it.
> 
> Ok, I'll keep an eye out for updates.  Presumedly we're talking 2.6.31 or
> .32 here.

Already in .31-rc1 there's will more patches cleaning up ide-tape so if you
could try that and send us bug reports will be simply swell :).

Thanks.

-- 
Regards/Gruss,
    Boris.
