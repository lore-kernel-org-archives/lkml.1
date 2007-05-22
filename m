Return-Path: <linux-kernel-owner+w=401wt.eu-S934112AbXEVOKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112AbXEVOKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 10:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbXEVOKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 10:10:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:41648 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308AbXEVOKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 10:10:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ws1SI8B8H9TqTnfLCvw9FrmpQ4xl9ebYH9fe6goUxjvSG1kWEUnNxESmnlee00Ot8dVzrU1wSQHujSXke+UFv2etuVJwx6qlELBeR0ctzPeWMLHN/ARw87BOnnRN289zGSkhXxSJLiCKpJm6xedvISn8B7Wp2dv5uaS14NqQJwc=
Message-ID: <a781481a0705220709s40b80208h47f1f2f7c00a684d@mail.gmail.com>
Date: Tue, 22 May 2007 19:39:59 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: any value to "NORET_TYPE" macro?
Cc: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705220959310.14408@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
	 <alpine.DEB.0.99.0705220950160.3308@sigma.j-a-k-j.com>
	 <Pine.LNX.4.64.0705220959310.14408@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Tue, 22 May 2007, John Anthony Kazos Jr. wrote:
>
> > >   given that:
> > >
> > > $ grep -r "define.*NORET_TYPE" *
> > > include/linux/ext4_fs.h:# define NORET_TYPE    /**/
> > > include/linux/linkage.h:#define NORET_TYPE    /**/
> > > include/linux/ext3_fs.h:# define NORET_TYPE    /**/
> > > $
> > >
> > > is there any obvious value to the 30 or so uses of that macro
> > > sprinkled throughout the tree?
> >
> > Since it evaluates to absolutely empty code during pre-processing,
> > there is no obvious value. The question is whether there is some odd
> > hackish non-obvious value, I'd expect. (I'd also expect that to be
> > another "no".)
> >
> > If something that evaluates to nothingness ("There was nothing
> > left...not even a hole!") actually does anything, then somebody in
> > the standards-compilers-users pipeline needs to be violently beaten
> > for stupidity.
>
>
> actually, one of the folks on the KJ list found this:
>
>   http://www.ussg.iu.edu/hypermail/linux/kernel/9605/1957.html
>
> which speaks thusly:
>
> ...
> -#if __GNUC__ < 2 || (__GNUC__ == 2 && __GNUC_MINOR__ < 5)
> -# define NORET_TYPE __volatile__
> -# define ATTRIB_NORET /**/
> -# define NORET_AND /**/
> -#else
> # define NORET_TYPE /**/
> # define ATTRIB_NORET __attribute__((noreturn))
> # define NORET_AND noreturn,
> -#endif
> ...
>
>   so it looks like a thoroughly obsolete macro which can be tossed.
> i'll make the patch and test it.

AFAICT, NORET_TYPE must've been introduced to silence gcc _warnings_,
and not do actually do anything useful that affects functionality in any way.
So the way to "test" your patch would be to see if there is any increase /
decrease in the number of *warnings* blurted out by gcc during kernel build
(best would be to build with various gcc versions on various platforms :-)

Satyam
