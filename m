Return-Path: <linux-kernel-owner+w=401wt.eu-S932881AbXCUQPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbXCUQPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932908AbXCUQPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:15:51 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:11233 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881AbXCUQPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:15:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=d/ePGeeLoDlGtiQ6FJeurxFE8fFNt+Rn0JW+NlsO3vkfxAUmHILroVdT8IlfB2Y25PhhE6EC/Iwkhpp2lMPX5BbV9kkaDKYc2L2c8X3anaLwIQNGz9bcp6rVXK06E95aQ89/Hd00Moev8xkyErfx5MprZ63hvU+zc4UYtM36PNw=
Message-ID: <2a12af650703210915r35d2d1a1q30f10020db269098@mail.gmail.com>
Date: Wed, 21 Mar 2007 18:15:47 +0200
From: "Marti Raudsepp" <marti@juffo.org>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Subject: Re: BUG: Files corrupt after moving LVM volume to USB disk
Cc: "Kernel hackers" <linux-kernel@vger.kernel.org>,
       fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20070321155039.GM22466@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2a12af650703200334u2b94bbcbt2aab8e94b6f2a527@mail.gmail.com>
	 <20070321155039.GM22466@csclub.uwaterloo.ca>
X-Google-Sender-Auth: 7777d8f51e8c3864
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/07, Lennart Sorensen <lsorense@csclub.uwaterloo.ca> wrote:
> Not that I really have a clue, but some questions anyhow:
Thanks for your response; I will answer the remaining questions after I've
freed up some space on the USB disk and done some additional tests. Possibly
later today, or maybe tomorrow.

> Do you ever unmount and shutdown the lvm during this test?
> What happens if you were to build the LVM and filesystem, then issue the
> move, and then reboot.  Can you then read them from the USB device or is
> it still corrupt?
Yes, when I first came across this problem, I had done several reboots, prior
to and following the lvmove; the filesystem-level corruptions remained
afterwards (though, as reported, everything worked fine again after moving it
back).

> Using any insane gentoo compiler options?
Nothing insane, just -fstack-protector -march=athlon64 -fomit-frame-pointer

> On Tue, Mar 20, 2007 at 12:34:08PM +0200, Marti Raudsepp wrote:
> > * Test partition is 68 extents times 16MiB = 1088 MiB large (that's the
> >  largest I could allocate while remaining in one segment -- otherwise lvmove
> >  wouldn't move the partition back to /dev/sda5 after "defragmenting" it.)
>
> That sounds strange.
I suppose it's a shortcoming of the current LVM mirror target -- when
allocating a larger LV on the primary disk, it initially creates the volume in
two segments; after done moving them to the secondary disk, it merges them into
one, as the two segments had been allocated continuously.

However, when attempting to move back the LV, the allocater can create two
extents, but the "mirror" LVM target does not appear to support regions that
are continuous on one copy and fragmented on another.

I even tried explicitly specifying --alloc= to lvmove, and it didn't have any
effect, confirming that it's not about allocation, but likely the "mirror"
stage of the move.

Regards,
Marti Raudsepp
