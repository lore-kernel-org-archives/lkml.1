Return-Path: <linux-kernel-owner+w=401wt.eu-S1759894AbZEBWEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894AbZEBWEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 18:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757692AbZEBWEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 18:04:22 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40398 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757340AbZEBWEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 18:04:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H6AiFlxIM8T7mVPUUsxBJsY7S6OADiT9800hBcxtbVrgjcDDGl5wzQqHCHMN14V1wx
         t3jzTbNxjOHUouDdggHq6ltsGSuFgOhLnXiqmP136Qnkc8lyen36niWfyMFJb+qtLvwm
         DVZIdGRjmFQEcVusZd12JpD0hviJFzNZzIEII=
MIME-Version: 1.0
In-Reply-To: <ac3eb2510905021439r2cef54fbja601f140d76ad623@mail.gmail.com>
References: <1241097822.2516.3.camel@poy> <20090502071636.GA9487@infradead.org>
	 <ac3eb2510905020434k57b561f7ld3db423f3dba26f0@mail.gmail.com>
	 <9b2b86520905021322l31845d2dubad98d78380aa1d5@mail.gmail.com>
	 <ac3eb2510905021439r2cef54fbja601f140d76ad623@mail.gmail.com>
Date: Sat, 2 May 2009 23:04:20 +0100
Message-ID: <9b2b86520905021504r3d32045ke1c14ffff1ffc898@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>, linux-arch@vger.kernel.org,
       viro@zeniv.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       adam@yggdrasil.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/09, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Sat, May 2, 2009 at 22:22, Alan Jenkins
> <sourcejedi.lkml@googlemail.com> wrote:
>
>> On a narrow issue: do you really object to moving the "mount dev -t
>> devfs2 /dev" into userspace (and therefore giving it a user-visible
>> name)??  That would address Cristophs particular objection about
>> "messing around" with the initial namespace.
>
> An argument which does not stand at all, there is no mess, it is not
> mounted at all until we are ready with initializing the kernel. And
> instead of creating some random nodes in /dev like we do today, we
> mount it, and it contains a node for every device. I hardly see any of
> the mentioned "namespace mess" here, it's just the simplest, most
> robust, and most efficient thing we can do. :)
>
>> It means I can be 100%
>> sure I can boot an old initramfs with this option enabled.
>
> Oh, it does not change anything for an existing initramfs, if that
> option enabled. After initramfs found and mounted the real rootfs at
> /root, your are totally free to call:
>   mount --move /dev/ /root/dev
> or not to do that, like we do today.

Sorry, you're right.  I should go to bed :-).

It would matter if you had a different naming scheme for /dev than the
kernel, and you were trying to get away with a static /dev.  I can't
believe anyone important does that though :-).

>> And it
>> gives a nice clean way for new initramfs' to test for this feature -
>> when they try to mount it, it fails.  It would seem to make for a
>> rather smoother migration path.
>
> I think that is all covered just fine.

Oh, I see.

grep "/dev" /proc/mounts > /dev/null

> One thing that I tried to solve by doing a kernel mounted fs, is that
> /dev on the rootfs is completely empty, it is that way on some distros
> today, and if you do init=/bin/sh, it will not work, because
> /dev/console is missing.
>
> Another thing, why I would like to avoid a new fstype is that
> userspace checks if /dev is a tmpfs to find out if it's a dynamic /dev
> - nothing really that should prevent us from doing a new filesystem,
> but we should need a good reason to do it, I think.

I thought udev was documented somewhere as compatible with a non-tmpfs
/dev, in a "just because you could" sort of way.  I've seen something
test for tmpfs... nevermind, it's probably something different.  (Just
the init script that checks whether /dev has been mounted that way by
an initramfs, or the user decided to do without intramfs'  so the
rootfs gets to mount it instead).

Good night
Alan
