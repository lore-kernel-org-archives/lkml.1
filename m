Return-Path: <linux-kernel-owner+w=401wt.eu-S933860AbXIBBE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860AbXIBBE7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 21:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933152AbXIBBEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 21:04:52 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3280 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932545AbXIBBEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 21:04:51 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Bob Beck" <beck@bofh.cns.ualberta.ca>, <bunk@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: [beck@bofh.cns.ualberta.ca: I respect the GPL immensely,really I do - but I believe this type of action weakens us all.]
Date: Sat, 1 Sep 2007 18:05:01 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEOHGIAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070901234952.GA16016@stusta.de>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 01 Sep 2007 18:05:26 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 01 Sep 2007 18:05:26 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> You miss the whole point of dual licencing:
> 
> Sam has stated in the licence that the code can be distributed under the 
> terms of the BSD licence, or alternatively it can be distributed under 
> the terms of the GPLv2.
> 
> Noone removed Sam's licence.
> 
> Sam has offered a choice, and if you choose one of the two offered 
> licences when distributing his code that complies with what he stated
> in his copyright notice.
> 
> IANAL, but if reyk contributed to dual licenced code keeping the file 
> dual licenced it's hard to argue that he did not make the changes he 
> made available dual licenced.

I think that there needs to be some general understanding about what the policy has to be when dual-licensed or BSD-licensed code is incorporated into the Linux kernel. Unfortunately, I don't think it's practical keep dual-licensed or BSD-licensed code in the Linux kernel because it prevents GPLv2 code from being incorporated into that file.

For example, if I make a file 'foo.c' available under a dual license, and it winds up in the Linux kernel, what happens? Suppose someone decides my locking is not optimal, and they cut/paste a few lines of code from another file, GPLv2 only, into 'foo.c'. Did they just put someone's GPLv2 code under a dual license? Of course not.

I think the policy should be:

1) If BSD-only code is incorporated into the Linux kernel, the BSD license must not be removed, as this is prohibited by the BSD license. However, a note should be included that only the original work is offered under the BSD license and that the license does not apply to the new elements that may have been added to that file. The file, as it presently sits, is likely only offered under the GPLv2.

2) If dual-licensed code is added to the Linux kernel, one of two things has to happen.

 A) If the code is relatively self-contained, it should stay dual-licensed. A warning should be placed in the file (with a pointer to a more detailed explanation) that GPLv2-only code cannot be spliced into this file without removing the dual-license.

 B) If the code is not relatively self-contained, or can no longer stay as A above due to the desire to splice in code from other modules are add GPLv2-only code, the GPL license should be removed.

I honestly wish that it would be possible to offer more code back to the BSD-licensed versions. If you know who I am, you know I'm a strong critic of the GPL license and much prefer the BSD license. However, I think Linux as a project suffers if it includes files available under different licenses. It's much harder to work with the code, modify it, and contribute to it.

Almost any consistent license is better than different files being under different licenses such that you are burdened with compliance issues when you try to move improvements from one file into another.

Imagine if every file system were under a different license and someon adds a new file system hook that every filesystem benefits from implementing. Suppose the original author submits an implementation for ext2 and it's under GPLv2. Think about the burdens if you then tried to implement that hook for three other filesystems, each with their own license, and you can't cut/paste the ext2 hook in.

DS


