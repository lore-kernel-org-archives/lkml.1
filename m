Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbZDBOsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbZDBOsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZDBOsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:48:42 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:45077 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbZDBOsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:48:41 -0400
X-Greylist: delayed 1056 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Apr 2009 10:48:41 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18900.52255.798522.393088@stoffel.org>
Date: Thu, 2 Apr 2009 10:30:55 -0400
From: "John Stoffel" <john@stoffel.org>
To: Andreas Robinson <andr345@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alain Knaff <alain@knaff.lu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib: add fast lzo decompressor
In-Reply-To: <1238613730.10514.35.camel@andreas-desktop>
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>
	<1238593252-3435-2-git-send-email-andr345@gmail.com>
	<49D3927A.2050406@zytor.com>
	<1238613730.10514.35.camel@andreas-desktop>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andreas" == Andreas Robinson <andr345@gmail.com> writes:

Andreas> On Wed, 2009-04-01 at 09:12 -0700, H. Peter Anvin wrote:
>> Andreas Robinson wrote:
>> > This patch adds an LZO decompressor tweaked to be faster than
>> > the 'safe' decompressor already in the kernel.
>> > 
>> > On x86_64, it runs in roughly 80% of the time needed by the safe
>> > decompressor.
>> > 
>> > This function is inherently insecure and can cause buffer overruns.
>> > It is only intended for decompressing implicitly trusted data, such
>> > as an initramfs and the kernel itself.
>> > 
>> > As such, the function is neither exported nor declared in a header.
>> > 
>> 
>> OK, I'm more than a bit nervous about that, especially since we're
>> trying to make the decompression functions more generic.

Andreas> Perhaps the system can default to the safe decompressor for
Andreas> normal use and choose the fast one if STATIC is defined or
Andreas> when system_state == SYSTEM_BOOTING?

So how do you prove that data is trusted?  What happens on buffer
overflow?  I don't think that a 20% speedup on decompression, with a
possibility of borking the boot completely is worth it.  Or are you
suggesting that people pre-test their initramfs images with this
compressor before deciding to boot from it?

Reliable booting is better than random crashes in my book.

John
