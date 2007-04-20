Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbXDTTRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbXDTTRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 15:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbXDTTRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 15:17:07 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:6353 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbXDTTRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 15:17:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NEmmlbnGQ2cm+mS4bi44Kcb9eUUwrjaxVwGicOZVfGIUc+nRHnVpEW27OptdCPgwgpJA3dsla5p2kQi33vDh1XMfhHwXgv84z9KL9Z55NeZFC19AM334NjyCQrwTRHGY4B70yUpet3dCPF33/Co1TQj5eBQ28XLz3Ak7PwMQNYI=
Message-ID: <a36005b50704201217l649195f0q204c2434445e7160@mail.gmail.com>
Date: Fri, 20 Apr 2007 12:17:02 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Andreas Gruenbacher" <agruen@suse.de>
Subject: Re: [d_path 0/7] Fixes to d_path: Respin
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200704201840.07247.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070412090809.917795000@suse.de>
	 <200704201721.29825.agruen@suse.de>
	 <a36005b50704200824i228f98ccq80f88a0f9d64abb2@mail.gmail.com>
	 <200704201840.07247.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/07, Andreas Gruenbacher <agruen@suse.de> wrote:
> The code also seems to stop at the first matching mount point. You can have
> the same device mounted on the same mount point multiple times but with
> different mount options, e.g., [...]

You can unfortunately do many stupid things.  That's the user's
problem.  The point is that everything works fine in an environment
which does not have such bogus mounts.  Namespaces are also the
problem of somebody else.  The people who came up with them didn't
think about the ramifications.  None of these problems can be
reasonably and reliably fixed with more support from the kernel.


> I gave a chroot example that showed that in the current
> implementation, you can get pretty random clashes between mounts; there are
> other cases with lazy unmounts as well.

Irrelevant as well.  If you create chroot problems it's your problem.

The fact is that if you have a normal setup the code works fine.  All
other situations cannot be handled with the current kernel interface.

This does not give anybody the right to say "since the code doesn't
always work we can break it completely".  That's completely
unacceptable.

If you want to improve the situation, do it.  Provide a solution for
the problems we are having in implementing statvfs.  Then we can talk
about stopping to use /proc/mounts for statvfs and you can change it
in a way which would harm the old implementation.  That's *my* view,
but I know there will be lots of people who would even object to that.
 The /proc filesystem is part of the kernel API and cannot be lightly
broken.
