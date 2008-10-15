Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbYJOMC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbYJOMC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 08:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYJOMCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 08:02:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:45014 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbYJOMCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 08:02:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=I6B3x91y02yb/UiTSu2+FKPj5Mr8fQvJtCiLjZfMNWAvTffnCc+dCQJYAB9nYWOMA8
         9EgodKtxk9ZRyIMBuco6bIO4udXM5Fj8cAtllzCVg3/T5PX+fUFFOR8pbKs+t9rsURpK
         7nR+Kki79bb0mEgLetPJoWWZgsDGmdqwwOTmM=
Message-ID: <b6a2187b0810150502m3b363b90q106102578e92811d@mail.gmail.com>
Date: Wed, 15 Oct 2008 20:02:18 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: linux 2.6.27 kernel panic on x86 - please revert commit 3a85e770aa77e4f1a4096275c97b64c10cd7323e
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
In-Reply-To: <20081015112324.GB31476@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0810151902510.19590@boston.corp.fedex.com>
	 <20081015112324.GB31476@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 7:23 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>
>> Commit 3a85e770aa77e4f1a4096275c97b64c10cd7323e broke linux boot on
>> x86 resulting in kernel panic. Here's the console output ...
>>
>> Net: Registered protocol family 17
>> Using IPI No-Shortcut mode
>> RAMDISK: Compressed image found at block 0
>> VFS: Mounted root (ext2 filesystem (readonly).
>> Freeing unsued kernel memory: 312k freed
>> init[1]: segfault at ffffe01c up b7f0dc28 sp bfc26628 error 5 in ld-2.7.90.so[b7f0b000+1c000]
>> Kernel panic - not syncing: Attempted to kill init!
>
> hm, ffffe01c is weird - VDSO on some ancient distro perhaps? Do you have
> CONFIG_COMPAT_VDSO=y enabled?
>
> if you have CONFIG_COMPAT_VDSO=y enabled but the read access still
> faults, then the question is, why is ffffe000 not mapped properly? The
> logic in arch/x86/vdso/vdso32-setup.c and map_compat_vdso() /
> arch_setup_additional_pages() seems correct and should result in the
> VDSO being mapped as user-readable.

Didn't realized that CONFIG_COMPAT_VDSO=y could cause this problem. I
had this set long time ago before upgrading to glibc-2.7

Unsetting CONFIG_COMPAT_VDSO solves the issue.

Thanks for your help, and sorry for the fault alarm. Did take a while
to trace it down to the commit.

Thanks,
Jeff.
