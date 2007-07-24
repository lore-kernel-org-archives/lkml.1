Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbXGXVVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbXGXVVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 17:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbXGXVVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 17:21:16 -0400
Received: from gw.goop.org ([64.81.55.164]:52200 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbXGXVVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 17:21:15 -0400
Message-ID: <46A66D12.1080804@goop.org>
Date: Tue, 24 Jul 2007 14:20:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Andi Kleen <andi@firstfloor.org>, Olaf Hering <olh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: Re: 2.6.22-git17 boot failure
References: <46A481FD.2030607@imap.cc> <46A4C081.6070305@goop.org> <46A504A3.3070205@imap.cc> <46A51079.5030006@goop.org> <46A53396.2060902@imap.cc> <46A5444D.4080304@goop.org> <20070724091018.GA26724@one.firstfloor.org> <20070724095614.GB625@suse.de> <46A64019.4010508@imap.cc> <46A64CD5.2030800@goop.org> <20070724191231.GA359@one.firstfloor.org> <46A665AB.9010207@imap.cc>
In-Reply-To: <46A665AB.9010207@imap.cc>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Apparently not, given that the generated init script is mistaking
> a native environment for a domU instead of a dom0.
>
> In fact, when running 2.6.23-rc1 natively, no matter if compiled
> with or without Xen support, the directory /proc/xen doesn't even
> exist:
>   

No, the in-tree Xen stuff doesn't do anything with /proc/xen, and I
don't think I'll try to merge anything that does.

> OTOH, the Opensuse Xen kernel vmlinuz-2.6.18.8-0.5-xen cannot even
> be booted natively because GRUB complains immediately:
>   Error 13: Invalid or unsupported executable format
> Conversely, the Xen loader flatly refuses to load a self-compiled,
> Xen enabled 2.6.23-rc1 kernel as dom0, complaining:
>   DOM0 image is not an Xen-compatible Elf image.
> So I guess the point is moot, because you cannot use the same image
> as dom0 and natively, anyway.
>   

No, but a dom0 kernel should look like a normal kernel from all the
device's perspective, with the added ability to fire up other domains. 
When I get around to adding dom0 support to the pvops kernel, this will
all get even more fluid.

The simple answer is that if you want to test if you can probe PCI/load
PCI device drivers, you should just go ahead and try; it will either
work or not.  No point testing something unrelated to see if you can.

The OpenSUSE init script is making the now-invalid assumption that you
can't have a CONFIG_XEN kernel that can talk to devices which isn't also
dom0.  It needs to have its horizons broadened.

    J
