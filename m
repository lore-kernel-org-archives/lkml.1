Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbYJEFyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbYJEFyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 01:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYJEFxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 01:53:48 -0400
Received: from ozlabs.org ([203.10.76.45]:34441 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbYJEFxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 01:53:47 -0400
Date: Sun, 5 Oct 2008 16:44:33 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: eranian@gmail.com
Cc: linux-kernel@vger.kernel.org,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: perfmon3 interface overview
Message-ID: <20081005054433.GB469@yookeroo.seuss>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	eranian@gmail.com, linux-kernel@vger.kernel.org,
	perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
References: <7c86c4470809231432j4231cfa4g7dd158a7fe9c9277@mail.gmail.com> <7c86c4470809251448j65fb99f1nfdb3980e0716149a@mail.gmail.com> <20081003061713.GL3002@yookeroo.seuss> <7c86c4470810030354x6984372akfe18761da7504a0c@mail.gmail.com> <7c86c4470810030358m1a0fdcc5i5512a1c2a6696457@mail.gmail.com> <7c86c4470810030412l34d3dc13mef10c9320884d635@mail.gmail.com> <20081004060506.GO30184@yookeroo.seuss> <7c86c4470810040020u126dfc1eg7d6db13078239e7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470810040020u126dfc1eg7d6db13078239e7e@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2008 at 09:20:00AM +0200, stephane eranian wrote:
> David,
> 
> On Sat, Oct 4, 2008 at 8:05 AM, David Gibson
> <david@gibson.dropbear.id.au> wrote:
> >>
> >> If we wanted to go even further, we could combine start/stop, attach/detach
> >> into  a single syscall:
> >
> > Well, you could.  But the attach/detach take a parameter which
> > start/stop don't, making it a less obvious merge to make.
> >
> Unless you make the 3rd argument optional and hide this in a
> user library. This is how this is handled for pfm_create_session()
> for instance. The library would define this as follows:
> 
>    int pfm_control_session(int fd, int flags, ...);
> 
> Based upon flags, it would use va_arg() to get to the 3rd argument and
> pass it to the syscall which implements the version below. A dummy value
> would be passed with the flags is not equal to PFM_CTFL_ATTACH.

Yeah, that's what I'm saying.  You could do it, but it feels like
you're forcing it, at least to me.  As you say it starts to look a bit
like ioctl() again.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
