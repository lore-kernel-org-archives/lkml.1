Return-Path: <linux-kernel-owner+w=401wt.eu-S1760963AbYCZSMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760963AbYCZSMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbYCZSMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:12:36 -0400
Received: from mail.queued.net ([207.210.101.209]:3841 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbYCZSMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:12:35 -0400
Date: Wed, 26 Mar 2008 14:13:01 -0400
From: Andres Salomon <dilinger@queued.net>
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: Stefan Pfetzing <dreamind@dreamind.de>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@redhat.com, hpa@zytor.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: GEODE: add missing module.h include
Message-ID: <20080326141301.2b675414@ephemeral>
In-Reply-To: <20080326175622.GB32151@cosmic.amd.com>
References: <88C5E610-F4BD-48FC-8673-D99D11C205D6@dreamind.de>
	<20080326175622.GB32151@cosmic.amd.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008 11:56:22 -0600
Jordan Crouse <jordan.crouse@amd.com> wrote:

> On 26/03/08 14:31 +0100, Stefan Pfetzing wrote:
> > Hello Jordan,
> >
> > I just tried to build your geodwdt driver for the geode watchdog. Therefore 
> > I pulled your repository from http://git.infradead.org/geode.git (or more, 
> > the git url).
> >
> > I tried to build the geodewdt driver as a module - which didn't work, and 
> > it failed with the same problem as earlier mentioned on lkmk [1]. I also 
> > checked the fix [2], but that seems to be already in your (or linus) tree - 
> > and so I'm unsure what the problem is.
> >
> > [1] http://kerneltrap.org/mailarchive/linux-kernel/2008/2/17/884074
> > [2] http://kerneltrap.org/mailarchive/linux-kernel/2008/2/17/884174
> >
> > Building directly into the kernel seems to work.
> >
> > Maybe you have some idea?
> 
> Hmm - that is strange.  Exporting the symbols should work.  I recommend
> starting over with a clean tree.
> 
> CCing Andres - any thoughts?
> 
> Jordan
> 


Er, yeah.  The patch below should fix it.  This should probably go into
2.6.25.





Oops, EXPORT_SYMBOL_GPL wasn't being declared due to this header
being missing.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 arch/x86/kernel/mfgpt_32.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/mfgpt_32.c b/arch/x86/kernel/mfgpt_32.c
index 3f0f603..2c0e6b5 100644
--- a/arch/x86/kernel/mfgpt_32.c
+++ b/arch/x86/kernel/mfgpt_32.c
@@ -30,6 +30,7 @@
 
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <asm/geode.h>
 
 static struct mfgpt_timer_t {
-- 
1.5.3.7

