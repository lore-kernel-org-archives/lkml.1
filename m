Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbZJAPzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbZJAPzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbZJAPzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:55:09 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:62515 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZJAPzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:55:08 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2009 11:55:07 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=h9p/ebm5evsEhKwRwfYMtw3PX2LKXRKOMkZlzV4vs/pR+QZoOkJlAGSXMnxh1YWEx4
         Ek56ZFyWCnZ0abGi3L1BEDq4N1Vq35+HA8Y4MWTKhJiYm97f5xxTDAuGS9p93pICNTbu
         pHO5KDHXKX371hV2hNJehJU2mSZVmBBmEYbLg=
MIME-Version: 1.0
In-Reply-To: <20091001145547.GA29152@shell>
References: <20091001145547.GA29152@shell>
Date: Thu, 1 Oct 2009 10:47:11 -0500
Message-ID: <7004b08e0910010847g3a901fb6n377b607bcdc0f766@mail.gmail.com>
Subject: Re: [RFC] Union mounts/writable overlays design
From: kevin granade <kevin.granade@gmail.com>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My apologies to anyone who has received this twice now, re-sending
after gmail added a html rider to the previous email, which was
rejected by lkml.  (A pox on "rich text" emails!)


Wow, amazingly thorough writeup, was a very interesting read and I'm
looking forward to trying this out.

>    Examples
>    ========
>
>    What happens when I...
>
>    - creat() /newfile -> creates on top layer
>    - unlink() /oldfile -> creates a whiteout on top layer
>    - Edit /existingfile -> copies up to top layer at open(O_WR) time
>    - truncate /existingfile -> copies up to top layer + N bytes if specified
>    - touch()/chmod()/chown()/etc. -> copies up to top layer
>    - mkdir() /newdir -> creates on top layer
>    - rmdir() /olddir -> creates a whiteout on top layer
>    - mkdir() /olddir after above -> creates on top layer w/ opaque flag
>    - readdir() /shareddir -> copies up entries from bottom layer as fallthrus
>    - link() /oldfile /newlink -> copies up /oldfile, creates /newlink on top layer
>    - symlink() /oldfile /symlink -> nothing special
>    - rename() /oldfile /newfile -> copies up /oldfile to /newfile on top layer

Minor quibble here, rename should also whiteout /oldfile, of course
you have it explained correctly in the detailed description of
rename() below.
Or am I misunderstanding and the above is what it does now and the
detailed description is what it will do once implemented properly?


>    Non-features
>    ------------
>
>    Features we do not currently plan to support as part of writable
>    overlays:
>
>    Online upgrade: E.g., installing software on a file system NFS
>    exported to clients while the clients are still up and running.
>    Allowing the read-only bottom layer to change while the writable
>    overlay file system is mounted invalidates our locking strategy.


So as long as the RO filesystem is NOT mounted as part of an overlay,
you could modify it and then re-construct the previous overlay and
things will work as expected?
For example could one create a hard drive over CD overlay, then
periodically (requiring a reboot probably) replace the underlying CD
with a new version and automagically have new versions of software
available?  ( obviously there are additional complexities in packaging
to make this work, but having support in the kernel is the first step.
)

One last thing, I don't see this in either the "features" or the
"non-features".  Will there be a way to "revert" a file to the RO
version once it has been copied up, either by just removing the
overlay entry or by somehow forcing the open of the underlying file
when it has an overlay?  Now that I think of it, one could just mount
the underlying filesystem elsewhere and copy the file, but I'd still
be interested to know if there is any desire to provide the more
"direct" operation.


>    Thank you for reading!


Thank you for writing!!!

-Kevin Granade
