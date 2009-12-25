Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZLYN7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZLYN7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 08:59:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZLYN7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 08:59:14 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:59623 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbZLYN7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 08:59:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OFIx9KiyWuzaPCyXlnNJc1b470i4GDRjmo5GgpwTK4ZCCZ7WwT4lrVnbNOszeEgPNp
         W3TYdWZEXgBmW7k2LTqsutcotSt5lwqsm0/Enb86jTRb0y3hd6WZNMzMhzqziZyHxPCL
         If93FRbnXnmqCh9vEXOy6mf0S7UhkPDV5wPt4=
MIME-Version: 1.0
In-Reply-To: <20091225024340.4431.59297.sendpatchset@localhost.localdomain>
References: <20091225024340.4431.59297.sendpatchset@localhost.localdomain>
Date: Fri, 25 Dec 2009 20:59:08 +0700
Message-ID: <5d75f4610912250559k26463e8fi1c38e54f31ba5120@mail.gmail.com>
Subject: Re: [Patch] console: limit the range of VGACON_SOFT_SCROLLBACK_SIZE
From: BuraphaLinux Server <buraphalinuxserver@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/09, Amerigo Wang <amwang@redhat.com> wrote:
>
> BuraphaLinux reported that we will trigger a mm warning when
> we CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=65536, this is because
> mm cann't allocate so many pages. We should limit the range
> of CONFIG_VGACON_SOFT_SCROLLBACK_SIZE, don't give a user
> any chance to trigger that.
>
> Reported-by: John Gatewood Ham <buraphalinuxserver@gmail.com>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>
>
> ---
> diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
> index fc7d9bb..8e8f18d 100644
> --- a/drivers/video/console/Kconfig
> +++ b/drivers/video/console/Kconfig
> @@ -37,6 +37,7 @@ config VGACON_SOFT_SCROLLBACK
>  config VGACON_SOFT_SCROLLBACK_SIZE
>         int "Scrollback Buffer Size (in KB)"
>         depends on VGACON_SOFT_SCROLLBACK
> +       range 1 1024
>         default "64"
>         help
>           Enter the amount of System RAM to allocate for the scrollback
>

This fixed the problem.  Thank you for the fix.  I texted on 2.6.32.2
with your patch added, x86_64 kernel.

Tested-by: John Gatewood Ham <buraphalinuxserver@gmail.com>
