Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbYDJRbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbYDJRbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 13:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbYDJRbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 13:31:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbYDJRbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 13:31:04 -0400
Date: Thu, 10 Apr 2008 10:30:16 -0700
From: Greg KH <gregkh@suse.de>
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: Paul Jackson <pj@sgi.com>, travis@sgi.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: add cpus_scnprintf function v3
Message-ID: <20080410173016.GA28068@suse.de>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com> <36ca99e90804091051k7c2cc97neba0ca1967625433@mail.gmail.com> <20080410071009.a5232b12.pj@sgi.com> <36ca99e90804100914n4b08cc9di9a6ab8b936f25644@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36ca99e90804100914n4b08cc9di9a6ab8b936f25644@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 06:14:55PM +0200, Bert Wesarg wrote:
> On Thu, Apr 10, 2008 at 2:10 PM, Paul Jackson <pj@sgi.com> wrote:
> > Bert wrote:
> >  > Btw, I think you can now push for a deprecation of the 'old' mask
> >  > attributes, with the justification you have given above. The other
> >  > possibility is to change sysfs to provide bigger attribute buffers
> >  > (CCed Greg for this).
> >
> >  On the other hand, and my main point of this message, I can't
> >  see deprecating the mask format files on account of this sort
> >  of analysis.
> >
> My statement from above doesn't reflect my opinion. I'm still in
> flavor with the mask output. And from this discussion, I found a new
> point for the mask output: its bounded ;-)
> 
> I just wanted to note, that these new list attributes would be the
> only way to 'change' the api, ie. introduce a new api and deprecate
> the old one, and not change the format of the present api.
> 
> Unfortunately, to support the mask attributes beyond 4k cpus, sysfs
> has to support greater attribute buffers.

Well, it does already today, you just have to work at it :)

What we can do for these types of files, is to use the "binary
attribute" file format.  With that, you get full control over the buffer
size and other operations.

So someone should just wrap up the cpu mask sysfs file usage in a
function that uses the binary attribute instead.  Then everyone who uses
the cpu mask in a sysfs file can use that function instead.

Sound reasonable?

thanks,

greg k-h
