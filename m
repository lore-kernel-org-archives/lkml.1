Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbZEKOnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbZEKOnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756372AbZEKOm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:42:28 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:13690 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbZEKOm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:42:26 -0400
MIME-Version: 1.0
In-Reply-To: <20090511073053.4628b28c@infradead.org>
References: <20090509143742.GA27663@kroah.com> <20090510170016.1e3a4d97@infradead.org> 
	<ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com> 
	<m1pregmkld.fsf@fess.ebiederm.org> <ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com> 
	<20090511115504.568c9a92@lxorguk.ukuu.org.uk> <ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com> 
	<20090511141057.24a5f8ed@lxorguk.ukuu.org.uk> <ac3eb2510905110714m5877da13q19b42d1c8565777c@mail.gmail.com> 
	<20090511073053.4628b28c@infradead.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 11 May 2009 16:42:06 +0200
Message-ID: <ac3eb2510905110742h7cd0a546ra922cc2001affd91@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 16:30, Arjan van de Ven <arjan@infradead.org> wrote:
>> But he does not use an initramfs, and distros insist to do that. And
>> that basically means you need to prepare /dev two times, and also prep
>
> eh why?
>
> this is the part I'm missing.
> Make /dev in the initramfs, then bind-mount-move it to its final
> location later.

Yeah, sure, that's what distros do, if initramfs was used.

> you ever only need to fill your tmpfs /dev once. initramfs or not.

But you do need to support non-initramfs boot on the same system too,
so you get to provide all that bootstrap logic, mount an empty /dev
and such, ... installed a second time to possibly run from the real
rootfs. That step is partly skipped if initramfs did the tmpfs thing
already, but ...

Initramfs is only used to mount the root and then you leave it behind
you as soon as you can. Only on the real root you find all the
additional udev rules, and tools, which are not available in
initramfs, and you need to re-run the coldplug to apply the
permissions, group ownership, create the configured symlinks, and run
the tools to setup devices.

All these steps involve hard checkpoints where you have to delay other
things that might need device nodes which need to be created first.
Depending on the actual boot setup where you did the bootstrap, the
checkpoint vary.

Thanks,
Kay
