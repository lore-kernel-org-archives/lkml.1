Return-Path: <linux-kernel-owner+w=401wt.eu-S1422673AbXCNVtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422673AbXCNVtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 17:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422674AbXCNVtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 17:49:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:31239 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422673AbXCNVta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 17:49:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=psG/APFrN/5JL7ccf1cOQ4JqvWdW9fVBzaFAsN9ml6cwFh8A2Uej4Ak7EaidWqusu2PIRwp/BT3Bz4K0/voMYypbLFkow2JPOrhOJYUaS9h+jy8VvIMozXP1ago5nASPhR+hsv3CCk74sOEIe4VZ2mmSnRDYs+omLJ+YCdxST1E=
Message-ID: <2c0942db0703141449h5f6eb2e4sadf493741d67ecc0@mail.gmail.com>
Date: Wed, 14 Mar 2007 14:49:28 -0700
From: "Ray Lee" <madrabbit@gmail.com>
Reply-To: ray-gmail@madrabbit.org
To: "Gene Heskett" <gene.heskett@gmail.com>
Subject: Re: New thread RDSL, post-2.6.20 kernels and amanda (tar) miss-fires
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200703132331.56140.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703130428.11014.gene.heskett@gmail.com>
	 <200703131436.33509.gene.heskett@gmail.com>
	 <200703132331.56140.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/07, Gene Heskett <gene.heskett@gmail.com> wrote:
> On Tuesday 13 March 2007, Gene Heskett wrote:
> >On Tuesday 13 March 2007, Gene Heskett wrote:
> >>Greetings;
> >>Someone suggested a fresh thread for this.
> >>
> >>I now have my scripts more or less under control, and I can report that
> >>kernel-2.6.20.1 with no other patches does not exhibit the undesirable
> >>behaviour where tar thinks its all new, even when told to do a level 2
> >> on a directory tree that hasn't been touched in months to update
> >> anything.
> >>
> >>Next up, 2.6.20.2, plain and with the latest RDSL-0.30 patch.
> >
> >And amanda/tar worked normally for 2.6.20.2 plain.
> >
> >Next up, 2.6.21-rc1 if it will build here.
>
> It built, it booted, and its busted big time.  First, with an amdump
> running in the background, the machine is so close to unusable that I
> considered rebooting, but I needed the data to show the problem.  I am
> losing the keyboard and mouse for a minute or more at a time but the
> keystrokes seem to be being registered so it eventually catches up.
>
> Disk i/o seems to be the killer according to gkrellm.
>
> But to give one an idea of the fits this is giving tar, I'll snip a line
> or 2 from an amstatus report here:
> coyote:/GenesAmandaHelper-0.6 1 planner: [dumps way too big, 138200 KB,
> must skip incremental dumps]
>
> Huh?  138.2GB?  A 'du -h .' in that dir says 766megs.
>
> coyote:/root                  1     4426m wait for dumping
> du -h says 5.0GB so that's ballpark, but its also a level 1, so maybe 20
> megs is actually new since 15:57 this afternoon local.  kmails final
> maildir is in that dir.
>
> This goes on for much of the amstatus report, very few of the reported
> sizes are close to sane.
>
> Now, can someone suggest a patch I can revert that might fix this?  The
> total number of patches between 2.6.20 and 2.6.21-rc1 will have me
> building kernels to bisect this till the middle of June at this rate.

In a previous email, you said you were using ext3. If that's the case,
there doesn't appear to be much going on in terms of patches between
2.6.20 and 2.6.21-rc1. The only one that even comes close to looking
like it might have an effect would only come in to play if you have a
filesystem that has ACL information, but is mounted by a kernel that
doesn't have ACL support.

I have to echo wli here, I'm afraid, and recommend at least a *few*
bisections to help narrow down the list of suspect patches.

There are tutorials out there for git users. I use the mercurial
repository, as I find the mercurial interface and workflow a lot more
intuitive, but it has the same capability.

Even 2-5 bisections will greatly help others hunt the bug down.

Ray
