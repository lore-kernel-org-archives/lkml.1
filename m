Return-Path: <linux-kernel-owner+w=401wt.eu-S1761504AbYCCEpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761504AbYCCEpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 23:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYCCEph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 23:45:37 -0500
Received: from n8.bullet.mail.tp2.yahoo.com ([203.188.202.89]:25634 "HELO
	n8.bullet.mail.tp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751608AbYCCEpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 23:45:36 -0500
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Mar 2008 23:45:35 EST
X-Yahoo-Newman-Id: 822902.80929.bm@omp406.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MqjcCSwSZI1eFKxu6Rv+VVvGk4E1RrDPWGIVCpWKVXG5+5JytbUa8lM3myAEdkRgVlxeufV7BV7gbB7ypVi6F+P1vQJ354bAz3Y/NBGzBx673mKx1MW0xMH0O9MlDh2zmEE2wAelY3jex09foyri4XMYLXvucly1YoAh7IrHRp0=  ;
X-YMail-OSG: Sx8bYIoVM1kMFCcLiyVRTldAgpDKGQ.BrZfojMZyRtODS7v7768dkooO3.f.IiD4KGLGrHd.Cg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Kevin Coffman" <kwc@citi.umich.edu>
Subject: Re: 2.6.24-sha1: RIP [<ffffffff802596c8>] iov_iter_advance+0x38/0x70
Date: Mon, 3 Mar 2008 15:38:34 +1100
User-Agent: KMail/1.9.5
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20080210140031.GA1754@martell.zuzino.mipt.ru> <200802261446.57109.nickpiggin@yahoo.com.au> <4d569c330802270941p681eb337x9a6d9cbcc2c4687f@mail.gmail.com>
In-Reply-To: <4d569c330802270941p681eb337x9a6d9cbcc2c4687f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031538.35271.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 February 2008 04:41, Kevin Coffman wrote:
> On Mon, Feb 25, 2008 at 10:46 PM, Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > On Wednesday 20 February 2008 09:01, Alexey Dobriyan wrote:
> > > On Tue, Feb 19, 2008 at 11:47:11PM +0300,  wrote:
> >  > > > Are you reproducing it simply by running the
> >  > > > ftest03 binary directly from the shell? How many times between
> >  > > > oopses? It is multi-process but no threads, so races should be
> >  > > > minimal down this path -- can you get an strace of the failing
> >  > > > process?
> >  >
> >  > Speaking of multi-proceseness, changing MAXCHILD to 1, nchild to 1,
> >  > AFAICS, generates one child which oopses the very same way (in
> >  > parallel with generic LTP) But, lowering MAXIOVCNT to 8 generates no
> >  > oops.
> >
> >  Thanks, I was able to reproduce quite easily with these settings.
> >  I think I have the correct patch now (at least it isn't triggerable
> >  any more here).
> >
> >  Thanks,
> >  Nick
>
> Hi Nick,
> With this patch, I'm getting "bad data" errors while running the
> connectathon tests from a Solaris NFS client to my Linux server.  (The
> failing test writes a "big" file (1MB) and reads it back, verifying
> the data read back is correct.)  Let me know if I can provide more
> details.

Hmm, thanks for testing... Could it be caused by other bugs introduced
in the kernel you are testing? Is the failing test using writev to
write the file? Do you have any indication of the pattern of corruption?

Thanks,
Nick

