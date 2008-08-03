Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbYHCR0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbYHCR0f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 13:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbYHCR00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 13:26:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:61484 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbYHCR0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 13:26:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lJgBm9XL9iaboz1W6pJCChRAjLIEoALDbkdhtqCrPDc0LsZTGAnbgyJ7l73Z+tvjj1
         zwFqQ+g3jNe3MZcymxkBVlr3+3dT6sP/AoBt6XoHOmzSd/Rh5nYYFiLwoT3/eiAUJGxT
         JHUxIyZ87n4IhpH16KY27pM61kElB6vgdGjfM=
Date: Sun, 3 Aug 2008 19:25:48 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Glauber Costa <gcosta@redhat.com>,
       Pavel Machek <pavel@suse.cz>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86, acpi: temp_stack is used only when CONFIG_SMP is
	set
Message-ID: <20080803172535.GE5414@joi>
References: <20080803165210.GC5414@joi> <alpine.LNX.1.10.0808031901120.7765@titan.stealer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0808031901120.7765@titan.stealer.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2008 at 07:07:30PM +0200, Sven Wegener wrote:
> On Sun, 3 Aug 2008, Marcin Slusarz wrote:
> 
> > arch/x86/kernel/acpi/sleep.c:24: warning: 'temp_stack' defined but not used
> > 
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Cc: Glauber Costa <gcosta@redhat.com>
> > Cc: Pavel Machek <pavel@suse.cz>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > ---
> >  arch/x86/kernel/acpi/sleep.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
> > index fa2161d..9103cb6 100644
> > --- a/arch/x86/kernel/acpi/sleep.c
> > +++ b/arch/x86/kernel/acpi/sleep.c
> > @@ -20,7 +20,7 @@ unsigned long acpi_realmode_flags;
> >  /* address in low memory of the wakeup routine. */
> >  static unsigned long acpi_realmode;
> >  
> > -#ifdef CONFIG_64BIT
> > +#ifdef CONFIG_SMP
> >  static char temp_stack[10240];
> >  #endif
> >  
> 
> Now it still generates the warning, but on i386 with CONFIG_SMP set, 
> instead of x86_64 without CONFIG_SMP. We only need temp_stack, when both 
> CONFIG_64BIT and CONFIG_SMP are activated.

Yes. Thanks for looking at the patch!

---
>From c6e673acf02e8bf04866cadf17c1cb1fa4d852ea Mon Sep 17 00:00:00 2001
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] x86, acpi: temp_stack is used only when CONFIG_64BIT && CONFIG_SMP is set

arch/x86/kernel/acpi/sleep.c:24: warning: 'temp_stack' defined but not used

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Glauber Costa <gcosta@redhat.com>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Sven Wegener <sven.wegener@stealer.net>
---
 arch/x86/kernel/acpi/sleep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index fa2161d..81e5ab6 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -20,7 +20,7 @@ unsigned long acpi_realmode_flags;
 /* address in low memory of the wakeup routine. */
 static unsigned long acpi_realmode;
 
-#ifdef CONFIG_64BIT
+#if defined(CONFIG_SMP) && defined(CONFIG_64BIT)
 static char temp_stack[10240];
 #endif
 
-- 
1.5.4.5
