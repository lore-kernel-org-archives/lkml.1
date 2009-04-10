Return-Path: <linux-kernel-owner+w=401wt.eu-S933188AbZDJTu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbZDJTu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 15:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757118AbZDJTup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 15:50:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:37515 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757145AbZDJTuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 15:50:44 -0400
Subject: Re: [PATCH -tip] x86: acpi/sleep.c saved_magic fix overflow
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       josh@freedesktop.org
In-Reply-To: <20090410192939.GB25551@uranus.ravnborg.org>
References: <1239385015.3169.15.camel@ht.satnam>
	 <20090410175545.GB16843@elf.ucw.cz>
	 <20090410191334.GA25336@uranus.ravnborg.org>
	 <1239391016.3169.49.camel@ht.satnam>
	 <20090410192939.GB25551@uranus.ravnborg.org>
Content-Type: text/plain
Date: Sat, 11 Apr 2009 01:19:41 +0530
Message-Id: <1239392981.5943.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-10 at 21:29 +0200, Sam Ravnborg wrote:
> On Sat, Apr 11, 2009 at 12:46:56AM +0530, Jaswinder Singh Rajput wrote:
> > Sorry, I was confused by this sparse warning on 64 bit box:
> > 
> > CHECK   arch/x86/kernel/acpi/sleep.c
> >  arch/x86/kernel/acpi/sleep.c:107:16: warning: constant 0x123456789abcdef0 is so big it is long
> > 
> > atleast I found problem in sparse ;-)
> 
> Sparse tells you that the constant is so big it is long - correct.
> So rather than being implicit appending an L would make sparse happy.
> 
> So please use the constant 0x123456789abcdef0L and I think sparse is silenced.
> And code/functionality is the same.
> 

Yes, this fixes the sparse warning, Thanks :-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 7c243a2..3445d0f 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -104,7 +104,7 @@ int acpi_save_state_mem(void)
        initial_gs = per_cpu_offset(smp_processor_id());
 #endif
        initial_code = (unsigned long)wakeup_long64;
-       saved_magic = 0x123456789abcdef0;
+       saved_magic = 0x123456789abcdef0L;
 #endif /* CONFIG_64BIT */
 
        return 0;

--


