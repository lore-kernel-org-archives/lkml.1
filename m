Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbZHMKkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbZHMKkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZHMKkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:40:46 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:50619 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZHMKkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:40:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VdBvB7SHsFlnSFn46NJp19F1ABNKiRrZUSZRzAS8HKbHvGHd1L82Z1PnC6ub8Y9lhK
         g3yYCTrug0r/+jxysRPyh7eof7leIoHrL4/5zwjRaTi7MbUkF5zUq6azHmzceTizT7qB
         zWydc8VpWhTEzCm1S8a68+wZABuKM69YdTIvg=
MIME-Version: 1.0
Reply-To: q-funk@iki.fi
In-Reply-To: <11fae7c70908130244k3f20954ewa23c5a57fbd60410@mail.gmail.com>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera>
	 <u1L1PAbl8zG.A.UBD.ej1fKB@chimera>
	 <11fae7c70908130152j21f9f183m4f1c49d91fc7a7f9@mail.gmail.com>
	 <20090813090743.GA14352@elte.hu>
	 <11fae7c70908130244k3f20954ewa23c5a57fbd60410@mail.gmail.com>
Date: Thu, 13 Aug 2009 13:40:45 +0300
X-Google-Sender-Auth: b3b24db83d643c0f
Message-ID: <11fae7c70908130340w37782c04m861d2f429d639a9e@mail.gmail.com>
Subject: Re: [Bug #13941] x86 Geode issue
From: =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <q-funk@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Viro <viro@ftp.linux.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/13 Martin-Éric Racine <q-funk@iki.fi>:
> On Thu, Aug 13, 2009 at 12:07 PM, Ingo Molnar<mingo@elte.hu> wrote:
>> * Martin-Éric Racine <q-funk@iki.fi> wrote:
>>> Yes, this bug is still valid.
>>>
>>> Ubuntu kernel team member Leann Ogasawara and I are slowly
>>> bisecting our way through the changes that took place since 2.6.30
>>> to find the commit that introduced this regression. Please stay
>>> tuned.
>>
>> hm, the only outright Geode related commit was:
>>
>>  d6c585a: x86: geode: Mark mfgpt irq IRQF_TIMER to prevent resume failure
>>
>> the jpg at:
>>
>>  http://launchpadlibrarian.net/28892781/00002.jpg
>>
>> is very out of focus - but what i could decypher suggests a
>> pagefault crash in the VFS code, in generic_delete_inode().

This one might be a bit better:

http://launchpadlibrarian.net/30267494/2.6.31-5.24.jpg

>> Which could be a VFS bug, or a filesystem bug, or some unrelated
>> memory corruption hitting the inode data structure.
>
> It could indeed be many things.
>
> I've been trying to boot this into a larger framebuffer to be able to
> fit more data into my snapshots, but it appears that vga=795 doesn't
> work anymore. Have we reverted to Hex values again or is this just an
> issue of some kernel module missing from initrd?

Never mind. Seems that vesafb was blacklisted. Works now. See the
image above. :)

Martin-Éric
