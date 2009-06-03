Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbZFCQWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbZFCQWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 12:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757971AbZFCQWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 12:22:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:12581 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758253AbZFCQWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 12:22:16 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906030827580.4880@localhost.localdomain>
References: <20090530192829.GK6535@oblivion.subreption.com>
	 <20090530230022.GO6535@oblivion.subreption.com>
	 <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain>
	 <20090531022158.GA9033@oblivion.subreption.com>
	 <alpine.DEB.1.10.0906021130410.23962@gentwo.org>
	 <20090602203405.GC6701@oblivion.subreption.com>
	 <alpine.DEB.1.10.0906031047390.15621@gentwo.org>
	 <alpine.LFD.2.01.0906030800490.4880@localhost.localdomain>
	 <alpine.DEB.1.10.0906031121030.15621@gentwo.org>
	 <alpine.LFD.2.01.0906030827580.4880@localhost.localdomain>
Date: Wed, 3 Jun 2009 12:22:16 -0400
Message-ID: <7e0fb38c0906030922u3af8c2abi8a2cfdcd66151a5a@mail.gmail.com>
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change 
	ZERO_SIZE_PTR to point at unmapped space)
From: Eric Paris <eparis@parisplace.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       "Larry H." <research@subreption.com>, linux-mm@kvack.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, pageexec@freemail.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 3, 2009 at 11:38 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 3 Jun 2009, Christoph Lameter wrote:
>
>> On Wed, 3 Jun 2009, Linus Torvalds wrote:
>>
>> > The point being that we do need to support mmap at zero. Not necessarily
>> > universally, but it can't be some fixed "we don't allow that".
>>
>> Hmmm... Depend on some capability? CAP_SYS_PTRACE may be something
>> remotely related?
>
> But as mentioned several times, we do have the system-wide setting in
> 'mmap_min_addr' (that then can be overridden by CAP_SYS_RAWIO, so in that
> sense a capability already exists).
>
> It defaults to 64kB in at least the x86 defconfig files, but to 0 in the
> Kconfig defaults. Also, for some reason it has a "depends on SECURITY",
> which means that if you just default to the old-style unix security you'll
> lose it.
>
> So there are several ways to disable it by mistake. I don't know what
> distros do.

Fedora has it on.

As I recall the only need for CONFIG_SECURITY is for the ability to
override the check.

I think I could probably pretty cleanly change it to use
CAP_SYS_RAWIO/SELinux permissions if CONFIG_SECURITY and just allow it
for uid=0 in the non-security case?  Deny it for everyone in the
non-security case and make them change the /proc tunable if they need
it?

-Eric
