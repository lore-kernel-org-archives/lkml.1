Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbZCSGtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbZCSGtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 02:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754246AbZCSGs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 02:48:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:52762 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbZCSGs4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 02:48:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g/Iv/F1vohnfcQDlr5vfDQFl75L1pGYroc4tDvY99rm0miP+TOJCMH0IkUo82+HjiP
         STJyCSscKCtIKxnSRuifmCbmfhxF/9XZeCCxQJpxF+ooN3mqsKVQSQoJAn0dJTY03k1h
         eQdNtBMKJ5LVYKIyHqNEpuK3kxLsuoE5IELW0=
MIME-Version: 1.0
In-Reply-To: <20090319040809.GA29249@kroah.com>
References: <20090319040809.GA29249@kroah.com>
Date: Thu, 19 Mar 2009 16:48:54 +1000
Message-ID: <21d7e9970903182348v57a78188ocefe138d353ee197@mail.gmail.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core 
	changes
From: Dave Airlie <airlied@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
       Richard Purdie <rpurdie@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 2:08 PM, Greg KH <greg@kroah.com> wrote:
> Hi,
>
> Here's 5 patches that add the Intel Poulsbo/Morrestown DRM driver to the
> kernel tree.
>
> There are 4 patches that make changes to the DRM core, and one patch
> that adds the DRM driver itself.  The driver is added to the
> drivers/staging/ directory because it is not the "final" driver that
> Intel wishes to support over time.  The userspace api is going to
> change, and work is currently underway to hook up properly with the
> memory management system.

>
> However this work is going to take a while, and in the meantime, users
> want to run Linux on this kind of hardware.  I'd really like to add the
> driver to the staging tree, but it needs these core DRM changes in order
> to get it to work properly.
>
> Originally I had a patch that basically duplicated the existing DRM
> core, and embedded it with these changes and the PSB driver together
> into one big mess of a kernel module.  But Richard convinced me that
> this wasn't the "nicest" thing to do, and he did work on the PSB code
> and dug out these older DRM patches.
>
> The only thing that looks a bit "odd" to me is the unlocked ioctl patch,
> Thomas, is that thing really correct?
>
> David, I'd be glad to take the DRM changes through the staging tree, but
> only if you ack them.

First off, the non-staging patches need more complete changelog entries,
a bit of meaning goes a long way. I'll ack them if they are documented and
make sense. The unlocked ioctl hook makes sense to me at least!

Now the non-core DRM driver comes with some caveats no one mentioned,
only the userspace 2D is open, no userspace 3D is available and I've no idea if
one is forthcoming. Now I don't know enough about the Poulsbo to say this
drm implementation is secure and can't DMA over my password file.

There is no upstream X.org driver available for this yet, Ubuntu
shipped something
but really we should be at least seeing X.org and Mesa commitments from Intel
to supporting this code in the future before we go shipping it all in
the kernel.

Staging something with a very broken userspace API is going to be an nightmare,
its fine if my audio doesn't work, but when X fails to start people
are left in a lot worse
place, personally I would never stage any driver that can break the
users userspace
this badly when we finally do get a version we want to upstream
properly. GPU drivers
are not just a kernel bit, they are not like a network card or sound
driver, where the
userspace API is mostly defined or a filesystem where we have POSIX.

So really I'm NAKing this from ever entering the mainline in its
current form, without
a supporting roadmap and plans for the userspace bits.

Dave.

>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
