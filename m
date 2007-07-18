Return-Path: <linux-kernel-owner+w=401wt.eu-S932408AbXGROAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408AbXGROAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbXGROAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:00:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:59462 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbXGROA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:00:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hu8843//EpfhTp1cbairX2ilOodVb2pVNs8m0zW3Qc1hdizKptAOhL++gXkJuJjFRMNSt7fPFgyI+eKXG7tXG55zp+/dNl6PZkJJyy5Kn9J6ysQJaP8qM92QmsazfKicbsuHwvHdGlrTo5VYNTJvSvu/QT1uqzSk5a0hK6natH4=
Message-ID: <9a8748490707180700t60bdbe88tb5190ade4e4f0c35@mail.gmail.com>
Date: Wed, 18 Jul 2007 16:00:28 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: other potential candidates for removal?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707180631400.23141@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0707180631400.23141@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/07/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
>
>    a while back, i threw together this wiki page:
>
> http://fsdev.net/wiki/index.php?title=Stuff_to_be_removed
>
> feel free to comment.
>
Some comments on that list :

} PCMCIA IOCTL support
}
} Currently listed in the removal file as scheduled for deletion back
in November of 2005, but
} there's some debate as to whether it's really ready to go.

If you remove that don't you run the risk of breaking existing
userspace (something which we don't do lightly) ?  Same goes for other
IOCTL's on the list as well as the ulog support.

Also, some items seem to have made the list since they depend on
BROKEN_ON_SMP or have no active maintainer.  As for depending on
BROKEN_ON_SMP, as long as the drivers work fine on UP they may have
users, so removing them would constitute regressions for those users -
especially if there's no replacement driver. Wouldn't it be better to
try and get those BROKEN_ON_SMP drivers to become SMP safe instead of
just removing them (or just leave them as-is if they work for some
people on UP)?
As for the lack of an active maintainer being a partial reason for
removal. I don't agree with that. As long as the code works and gets
fixed up to continue working when other parts of the kernel evolve,
then I see no reason to remove the code just because noone is actively
maintaining it. Sometimes unmaintained code even grow new maintainers
after a while.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
