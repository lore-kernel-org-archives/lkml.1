Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbZBQLxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbZBQLxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 06:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZBQLx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 06:53:28 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:34516 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZBQLx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 06:53:27 -0500
MIME-Version: 1.0
In-Reply-To: <cc43514a0902170242m5af7e511ne00f424f06a5da22@mail.gmail.com>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <200902170921.56789.rusty@rustcorp.com.au>
	 <cc43514a0902170242m5af7e511ne00f424f06a5da22@mail.gmail.com>
Date: Tue, 17 Feb 2009 12:53:25 +0100
Message-ID: <ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Andreas Robinson <andr345@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 11:42, Andreas Robinson <andr345@gmail.com> wrote:
> On Mon, Feb 16, 2009 at 11:51 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>>  This isn't crazy.  But you'd need to benchmark against the minimal
>> userspace solution: a binary with all the modules built into
>> it which calls sys_init_module on each one, then does the root swizzle
>> or whatever.
>>
>> I think you'd find the difference to be in the noise.

Usual distro setups load like 100+ modules on every bootup. Modprobing
and symbol-resolving is serialized and uses stop_machine(), so there
might be some significant difference here when loading a huge number
of modules individually. Monolithic versus modular kernels usually
make about 2+ seconds difference on a recent laptop.

> your're right and I'll get right on it.

For distros it's probably more interesting not to get rid of the
initramfs, but possibly have the mkinitrd/mkinitramfs tool to pre-link
all the usual modules if faster bootup is expected. Having only the
few modules pre-linked which are usually included in the initramfs,
might, as Rusty expects, not make that much difference.

Kay
