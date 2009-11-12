Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZKLXb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZKLXb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbZKLXbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:31:24 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51838 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbZKLXbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:31:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ikABUANBd8w5M0xT+coeohk/LsmZYvCJ323l+RPjO4oPMoHH7vd+Y7SqCdQjkqD6RA
         JNmSDwM5e1hfq0DA3f3+ft/DpzLyHhpeJcqC5AB7N9n4/R2z4+y+nVU/5wGWNOIi9BCv
         5Ar5F1XLNI55RFckpbbbpPQMNzY2T6A7iHcYc=
MIME-Version: 1.0
In-Reply-To: <1258067006-2205-1-git-send-email-lrodriguez@atheros.com>
References: <1258067006-2205-1-git-send-email-lrodriguez@atheros.com>
Date: Thu, 12 Nov 2009 23:31:28 +0000
Message-ID: <9b2b86520911121531y70e05d4rcd361ec33799bc0a@mail.gmail.com>
Subject: Re: [RFC] scripts: add gen-linux-conf for remote kernel configuration
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, greg@kroah.com,
       akpm@linux-foundation.org, mcgrof@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/09, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
> The new 'make localmodconfig' proves very useful but on low end
> systems we do not want to 'git clone' an entire kernel tree or
> download a whole kernel but just cross compile the kernel on a
> bigger machine. The .config generated with 'make localmodconfig'
> is still very helpfup though so to aid users and developers
> with that add a script which builds a tarball with only the
> necessary kernel glue stuff to be able to generate a local
> minimum kernel configuration with 'make localmodconfig'.
>
> With this you can copy to your target device a relatively
> small tarball (1.2 MB currenty) and, allows you to modify
> the kernel config for your tree (mconf, conf, etc) and
> finally run 'make localmodconfig'.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>
> I had an itch to scratch and that was to use 'localmodconfig'
> on a small netbook but I didn't want to clone a whole tree
> or even compile an entire kernel on it. This did the trick,
> thought others might find it useful.
>
> A little grimy the bash script, but hey it works and its simple
> enough. I tried to reduce the Makefile count to only arch/ but
> found that that didn't do the trick. Perhaps this can be optimized
> more, suggestions welcomed. Maybe it should be written in Go :)
>
> What would be *real* nice is to give an IP address of a box and
> have it build and fetch a localmodconfig .config for you.
>
>   Luis

Thanks for posting this.

When I tried this for my netbook, my approach was to copy
/proc/modules and /boot/config from the netbook.  As a shameless hack,
I temporarily bind mounted /proc/modules on the build system.  I guess
the cleaner way would be to copy the result of "lsmod", and have
localmodconfig accept "LSMOD_FILE=file".

Naturally I think my approach is simpler, despite not having actually
implemented it properly :).  What do you think about it?

Regards
Alan
