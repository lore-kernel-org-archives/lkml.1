Return-Path: <linux-kernel-owner+w=401wt.eu-S932179AbXD2Gwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179AbXD2Gwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 02:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754519AbXD2Gwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 02:52:53 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57179 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbXD2Gwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 02:52:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bart Trojanowski <bart@jukie.net>
Cc: fastboot@lists.osdl.org, linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [Fastboot] restoring x86 BIOS state before reboot
References: <20070406154628.GG12005@jukie.net>
Date: Sun, 29 Apr 2007 00:51:09 -0600
In-Reply-To: <20070406154628.GG12005@jukie.net> (Bart Trojanowski's message of
	"Fri, 6 Apr 2007 11:46:28 -0400")
Message-ID: <m1zm4rd676.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Trojanowski <bart@jukie.net> writes:

> Hi all,
>
> I am looking at a two stage boot where linux is loaded to do some system
> initialization before booting to Windows, which needs BIOS.
>
> I am interested in bypassing the BIOS on the second boot.
>
> I wanted to know if anyone has attempted to restore the BIOS memory such 
> that this could be attempted.  If not, I would love to get some pointers
> :)
>
> My plan right now is to backup the 128k of memory under 0x10000 to some
> staging memory under 0x90000, temporarily while in real mode, and then
> move it up somewhere higher once the kernel is running.
>
> Then on reboot I hope to undo the above and jump to 0x00007c00.
>
> Does this approach have any merit?

The primary problem isn't so much the BIOS memory.  That is usually
preserved.  But rather the BIOS gets confused at the massive change
in hardware state.  At least I think that is what happens.

On some BIOS/kernel configuration it isn't a problem I think I
got maybe a 20% success rate trying to use the 16bit linux entry
point that starts the new kernel from kexec when I was investigating
it.

You might get a little more success if you backup the BIOS memory
I don't know.

As long as you are not coming out of a panic situation there is
no theoretical reason why you shouldn't get the BIOS back and
working again, but the how of it is a challenge.

The possibility I keep playing with is to load the Bochs BIOS or
some other implementation of the basic boot services that I have
control over so that if it doesn't work the code can be fixed.
There has been some limited success with this technique in the
context of LinuxBIOS.

The ACPI tables should be reusable as is.

It may also be worth investigating if it is possible to bypass
the part of windows that uses BIOS calls.  I really don't have
a clue how a modern windows systems boots.

Eric
