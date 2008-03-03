Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbYCCNbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbYCCNbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 08:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYCCNa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 08:30:56 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:38249 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbYCCNaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 08:30:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=N+al+v+/ycnp64/bz7imejXNPjMPrHAj0Kl3WWxwhqmzQT0u94HDkd8UA82Z1eu7Sgi7dX1eJq1spC110gpkDJpGyCgXEQ3OHgcWXDhOx7hae8jeMYELGMZQc7PKsP5JxbsCEyX81suW2/QlihntsU+c+UOF7eoi8Laav+njhlo=
Message-ID: <4d569c330803030530j76a47249ic4e3eb2d86283d6f@mail.gmail.com>
Date: Mon, 3 Mar 2008 08:30:51 -0500
From: "Kevin Coffman" <kwc@citi.umich.edu>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.24-sha1: RIP [<ffffffff802596c8>] iov_iter_advance+0x38/0x70
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200803031538.35271.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080210140031.GA1754@martell.zuzino.mipt.ru>
	 <200802261446.57109.nickpiggin@yahoo.com.au>
	 <4d569c330802270941p681eb337x9a6d9cbcc2c4687f@mail.gmail.com>
	 <200803031538.35271.nickpiggin@yahoo.com.au>
X-Google-Sender-Auth: fc5366920eb902b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 2, 2008 at 11:38 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>
> On Thursday 28 February 2008 04:41, Kevin Coffman wrote:
>  > On Mon, Feb 25, 2008 at 10:46 PM, Nick Piggin <nickpiggin@yahoo.com.au>
>  wrote:
>  > > On Wednesday 20 February 2008 09:01, Alexey Dobriyan wrote:
>  > > > On Tue, Feb 19, 2008 at 11:47:11PM +0300,  wrote:
>  > >  > > > Are you reproducing it simply by running the
>  > >  > > > ftest03 binary directly from the shell? How many times between
>  > >  > > > oopses? It is multi-process but no threads, so races should be
>  > >  > > > minimal down this path -- can you get an strace of the failing
>  > >  > > > process?
>  > >  >
>  > >  > Speaking of multi-proceseness, changing MAXCHILD to 1, nchild to 1,
>  > >  > AFAICS, generates one child which oopses the very same way (in
>  > >  > parallel with generic LTP) But, lowering MAXIOVCNT to 8 generates no
>  > >  > oops.
>  > >
>  > >  Thanks, I was able to reproduce quite easily with these settings.
>  > >  I think I have the correct patch now (at least it isn't triggerable
>  > >  any more here).
>  > >
>  > >  Thanks,
>  > >  Nick
>  >
>  > Hi Nick,
>  > With this patch, I'm getting "bad data" errors while running the
>  > connectathon tests from a Solaris NFS client to my Linux server.  (The
>  > failing test writes a "big" file (1MB) and reads it back, verifying
>  > the data read back is correct.)  Let me know if I can provide more
>  > details.
>
>  Hmm, thanks for testing... Could it be caused by other bugs introduced
>  in the kernel you are testing? Is the failing test using writev to
>  write the file? Do you have any indication of the pattern of corruption?
>

Well, all I did was apply your patch and re-run the same tests I've
been running successfully.   (I'm still sitting at 2.6.25-rc1 right
now).  Sorry, I don't have details about the corruption.  I'm home
sick today, but I'll try to get more details when I get back in the
office.

K.C.
