Return-Path: <linux-kernel-owner+w=401wt.eu-S1762415AbYBWCX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762415AbYBWCX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 21:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbYBWCXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 21:23:51 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:26474 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbYBWCXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 21:23:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mUXCo3gRshgMlKm5xxVXSIlCXRGjZ5nFXG80UKf/MTC01VCxv/kDf1HjUvb0/PwA3OMyKjRKtOtCprsaWA7/KkrRYJIZLcPlxgYuIAVW57t86in/52c2L84W0AW34mjOXM1uroKCQPALlOSi949fpuvfPV1nI6V0uyc00gnm68I=
Message-ID: <998d0e4a0802221823h3ba53097gf64fcc2ea826302b@mail.gmail.com>
Date: Sat, 23 Feb 2008 03:23:49 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: "Al Viro" <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question about your git habits
In-Reply-To: <20080223020913.GL27894@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802221837.37680.chase.venters@clientec.com>
	 <Pine.LNX.4.64.0802230221140.21077@fbirervta.pbzchgretzou.qr>
	 <20080223014445.GK27894@ZenIV.linux.org.uk>
	 <7vfxvk4f07.fsf@gitster.siamese.dyndns.org>
	 <20080223020913.GL27894@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/2/23, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Feb 22, 2008 at 05:51:04PM -0800, Junio C Hamano wrote:
>  > Al Viro <viro@ZenIV.linux.org.uk> writes:
>  >
>  > > On Sat, Feb 23, 2008 at 02:37:00AM +0100, Jan Engelhardt wrote:
>  > >
>  > >> >do you tend to clone the entire repository repeatedly into a series
>  > >> >of separate working directories
>  > >>
>  > >> Too time consuming on consumer drives with projects the size of Linux.
>  > >
>  > > git clone -l -s
>  > >
>  > > is not particulary slow...
>  >
>  > How big is a checkout of a single revision of kernel these days,
>  > compared to a well-packed history since v2.6.12-rc2?
>  >
>  > The cost of writing out the work tree files isn't ignorable and
>  > probably more than writing out the repository data (which -s
>  > saves for you).
>
>
> Depends...  I'm using ext2 for that and noatime everywhere, so that might
>  change the picture, but IME it's fast enough...  As for the size, it gets
>  to ~320Mb on disk, which is comparable to the pack size (~240-odd Mb).

Yesterday, i had git cloned git://foo.com/bar.git   ( 777 MiB )
Today, i've git cloned git://foo.com/bar.git   ( 779 MiB )

Both repos are different binaries , and i used 777 MiB + 779 MiB = 1556 MiB
of bandwidth in two days. It's much!

Why don't we implement "binary delta between old git repo and recent git repo"
with "SHA1 built git repo verifier"?

Suppose the size cost of this binary delta is e.g. around 52 MiB instead of
2 MiB due to numerous mismatching of binary parts, then the bandwidth
in two days will be 777 MiB + 52 MiB = 829 MiB instead of 1556 MiB.

Unfortunately, this "binary delta of repos" is not implemented yet :|
