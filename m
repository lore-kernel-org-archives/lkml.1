Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbYGNQbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbYGNQbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYGNQbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:31:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:32523 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbYGNQbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:31:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=EYd/uGNHfeEjAbMU0233Z21C/7PJoep24lCbtx/W4iYNoXojwmF8rgHnEy+k2AjpAy
         PHMebpz1BAi1IqTl8ulOjnZKgPboNKBa8N0b3irr+O7YoDW1Uw5gdD3Z+6TeZy2Hdkdj
         uyggzIMd3PEi8v5W/8d1o49NkMkHfdBB7DXbM=
Message-ID: <2c0942db0807140931j53d53bb8oae4f1b442fbc7018@mail.gmail.com>
Date: Mon, 14 Jul 2008 09:31:01 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Suspend-devel] TAP (and TUN?) devices not working after resume
Cc: "James Le Cuirot" <chewi@aura-online.co.uk>,
       suspend-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       "pm list" <linux-pm@lists.linux-foundation.org>, netdev@vger.kernel.org
In-Reply-To: <200807141812.45264.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080714154720.791f6640@symphony> <200807141812.45264.rjw@sisk.pl>
X-Google-Sender-Auth: 064fa4e38c1f265a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 9:12 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, 14 of July 2008, James Le Cuirot wrote:
>> uswsusp works great on my machine except for one thing. I use a TAP
>> device for QEMU and after resuming from suspend, it doesn't work
>> anymore until I delete it and recreate it. This is rather annoying
>> because if I have QEMU open, it means I have to close it before
>> recreating the interface and then boot Windows up again. I use OpenVPN
>> to create/delete the interface but I think that's all it does. The rest
>> is done by the kernel. So I'm guessing something's up with the TUN/TAP
>> driver or uswsusp itself. I'm using version 0.8. Sorry if this has
>> already been fixed.
>
> This is a kernel problem, adding kernel-related CCs.

Oh, hmm. I noticed this about a year ago after a kernel upgrade, and
threw the below into /etc/acpi/resume.d/91-openvpn.sh to fix the issue
on resume. It was supposed to be temporary until I could track down
whether this was a kernel issue or whatnot, but then I sorta, uhm,
forgot to report it. But yeah, I see the same issue -- after resume,
the TUN device has disappeared, and openvpn needs to be told to close
and reopen for it to work again.

#!/bin/sh
# poke openvpn to rebuild the tunnel
if pidof openvpn > /dev/null; then
	killall -SIGHUP openvpn
fi
