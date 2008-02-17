Return-Path: <linux-kernel-owner+w=401wt.eu-S1753974AbYBQUXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbYBQUXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbYBQUWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:22:51 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:5122 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbYBQUWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:22:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VN/CUVGNWHrK/2sGxspTmSJ0yXFMnLRiFU967qXh0nYQqA+hxsPUimupCdLFu6cF3WIbjQTdXrTd7CPfQMhJ2I/+wnuCGr+4YuBpaRX/P0h80l7fnxG4jolsmaj9jlhpcU2nZe1RLF9be6MWMHJLe8r0q+SsxefAgHT71KE7U+Q=
Message-ID: <939d53060802171222m4619de97u3aa4ed7cb27e6e75@mail.gmail.com>
Date: Sun, 17 Feb 2008 21:22:48 +0100
From: "Benjamin Thery" <ben.thery@gmail.com>
To: "Frans Pop" <elendil@planet.nl>, davem@davemloft.net
Subject: Re: [2.6.25-rc2] System freezes ca. 1 minute after logging into KDE
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <200802171139.13615.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802171139.13615.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 17, 2008 11:39 AM, Frans Pop <elendil@planet.nl> wrote:
> (resend a third time because previous attempts never reached the lists
> due to a bug in my MUA; my apologies to David for spamming his inbox)
>
> Linus Torvalds wrote:
> > But hey, you can try to prove me wrong.  I dare you.
> Me too, me too!
>
> Weird issue this.
> About a minute after logging into KDE the system freezes, but only
> partially. The keyboard is completely dead in all cases (no console
> switching, no SysRq), but some tasks stay running. One time music continued
> playing, other times it stopped. One time the desktop clock continued
> ticking, other times it stopped. One time I could close a window using the
> mouse, but other windows were frozen.
> It's not just KDE that's frozen; one time I switched to VT1 before the
> freeze happened, but that became unusable too.
> Zilch in the logs.
>
> I've bisected it down to:
> commit 69cc64d8d92bf852f933e90c888dfff083bd4fc9
> Author: David S. Miller <davem@davemloft.net>
>     [NDISC]: Fix race in generic address resolution
>
> Confirmed that this is really the culprit by reverting this commit on top
> of -rc2, which is now running fine.
>
> I'm using IPv6 (local network only) together with IPv4, use a bridge (br0)
> and have an NFS4 mount active.

I've encountered the same issue last Thursday. Here, I can hang my machine
with ping6. I've also bisected it down to the same commit.

I've sent some kernel traces which shows how the soft lock up occurs. See
thread: "[PATCH][RFC] race in generic address resolution"
http://www.spinics.net/lists/netdev/msg55375.html

Benjamin


>
> Cheers,
> FJP
>
>
