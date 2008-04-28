Return-Path: <linux-kernel-owner+w=401wt.eu-S933059AbYD1Jwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059AbYD1Jwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbYD1Jwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:52:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:20643 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248AbYD1Jwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:52:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=StOJznMPakjckEIpZoT9q39AnGKafl4nA+eNYFEQo0G0ukjsuwXvSV49A8UBAI8+WHKFWN4vw57VLsjD9Z+SmOv5ZGDG/tqLuNlKbinYU5PSFnje/xZ+WGfao8eTQoo9pqn1d9lhc7gozSEClKzr1l8OInx7jMxDMQNgpaR4tJE=
Message-ID: <517f3f820804280252h753c8cacv7fe9580f96dcf1ce@mail.gmail.com>
Date: Mon, 28 Apr 2008 11:52:35 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Ulrich Drepper" <drepper@redhat.com>
Subject: Re: [PATCH] paccept, socket, socketpair w/flags
Cc: "Michael Kerrisk" <mtk.manpages@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <200804262224.m3QMOP3a006296@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804262224.m3QMOP3a006296@devserv.devel.redhat.com>
X-Google-Sender-Auth: aa295deb1f896118
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC+=Alan Cox]

On 4/27/08, Ulrich Drepper <drepper@redhat.com> wrote:
> This version of the patch hopefully integrates all of the requested
>  changes:
>
>  - the sock_map_fd interface is changed and all in-tree users changed.
>   No additional function anymore
>
>  - there is a helper function to convert the new socket flags into
>   file flags.  Shared by all three functions
>
>  - the new accept interface is now paccept() which adds the flag
>   parameter as well as a signal mask.
>
>  - not changed from the last version: the paccet() function takes
>   a flags parameter with the same value as the ORed flags for
>   socket() and socketpair().  Seems cleaner.

Ulrich,

This is ugly.  Why invent a diffent set of flags here.  I agree with
your earlier statement that new syscalls would be cleaner.  If, as
seems to be the case, we are going to create new syscalls for

eventfd()
signalfd()
accept()
dup2()
epoll_create()
pipe()
inotify_init()
(I've not seen those last two yet, but I assume you are going to do them.)

then *please* let's go the hwole way cleanly, and have new syscalls
also for socketpair() and socket(), and make all of the new syscalls
use the same flags.  Creating a different set of flags just to avoid a
couple of extra sycalls is ugly.  (You yourself asserted similar in
saying that dup3() is better than adding an extra flag to fcntl(), and
I don't disagree.)

Cheers,

Michael
