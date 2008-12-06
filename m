Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbYLFSMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbYLFSMB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 13:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYLFSLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 13:11:53 -0500
Received: from ik-out-1112.google.com ([66.249.90.182]:38437 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbYLFSLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 13:11:52 -0500
Message-ID: <ac3eb2510812061011u7a7f0fbdtc46b95a9c642f9c7@mail.gmail.com>
Date: Sat, 6 Dec 2008 19:11:50 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Evgeniy Polyakov" <zbr@ioremap.net>
Subject: Re: Runaway loop with the current git.
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <20081206165634.GA2516@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081205181610.518ecd13@lxorguk.ukuu.org.uk>
	 <20081205192755.GA27712@ioremap.net>
	 <20081205193432.290a6f1a@lxorguk.ukuu.org.uk>
	 <20081205211223.GA8075@ioremap.net>
	 <ac3eb2510812051317q79ca88e9ya876ffb94162eeca@mail.gmail.com>
	 <20081205212428.GB8075@ioremap.net>
	 <ac3eb2510812051810x8cf4256lf9fd31b15b9e0552@mail.gmail.com>
	 <20081206160927.GA498@ioremap.net>
	 <ac3eb2510812060816h4401c78bj6d656d0d5721024@mail.gmail.com>
	 <20081206165634.GA2516@ioremap.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 6, 2008 at 17:56, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> On Sat, Dec 06, 2008 at 05:16:06PM +0100, Kay Sievers (kay.sievers@vrfy.org) wrote:
>> So the loop is probably a modprobe itself that tries to access
>> /dev/console. Is there a different argument for the very first
>> modprobe which is called? Which may be the one that triggers the loop.
>
> Hard to tell, I did not see anything but modprobe before and after
> runaway loop message, but it could be missed though, I will tell
> for sure only this Monday.

Sounds good.

It seems the /dev/console driver is registered only after all the pci,
video, acpi, ... drivers, so it's not surprising, that if any of these
driver in these subsystems calls request_module(), or a process in
initramfs tries to access the "dead" /dev/console node, things will go
wrong.

Thanks,
Kay
