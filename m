Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbZJPUoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbZJPUoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 16:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZJPUoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 16:44:09 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:37344 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZJPUoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 16:44:08 -0400
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Oct 2009 16:44:08 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Aqq+VIJG3kAnxVUa6RNckDuTZ5XX07W/+j3HWGZw0+OkMNQyNDhpWw1Wc7cLp0a/qN
         QfQRjuncRAqrWnzFgb9WMft1542xl9OR/Co2YvUvWYYuouwDvoAN8mtcPpOkrtd0nP15
         VYF3AscmI7egaEb7L9cA32OjfDbRquyFSY1ws=
MIME-Version: 1.0
In-Reply-To: <b637ec0b0910161253y60eb6b4fl3e49e5b9129d81ac@mail.gmail.com>
References: <b637ec0b0910161253y60eb6b4fl3e49e5b9129d81ac@mail.gmail.com>
Date: Fri, 16 Oct 2009 22:36:34 +0200
Message-ID: <b637ec0b0910161336j7848b46eh4fcf69e450161afb@mail.gmail.com>
Subject: Re: [Regression] - 2.6.32-rc5 hangs using rfkill on an eeePC
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Darren Salt <linux@youmustbejoking.demon.co.uk>,
       Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually it was pretty easy to find the culprit, as thereare only two
eeepc-related commit between -rc4 and -rc5 and one is about the
camera.

Reverting:

[PATCH] eeepc-laptop: Prevent a panic when disabling RT2860 wireless
when associated

fixes the problem.

Commit-id is b56ab33d68638e6aafdbfc694025e8354a628f49

Regards,
Fabio


On Fri, Oct 16, 2009 at 9:53 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> Hi all.
> Pressing rfkill button on my eeePC 900 to disable wireless hangs the system.
>
> In console I can see (warning: what follows is copied by hand):
>
> acpid: client 148[6:100] has disconnected
> ACPI group/action not found: hotkey / ATKD
> unregister netdevice: waiting for wlan0 to become free; usage count=1
>
> (last line repeats forever). Hard reset is needed.
>
> With any previous kernel version (I'm running -rc4 right now) everything works:
>
> ACPI group/action undefined: hotkey / ATKD
> ath5k 0000:01:00.0: PCI INT A disabled
>
> (there's no acpid line)
>
>
> Regards,
> Fabio
>
