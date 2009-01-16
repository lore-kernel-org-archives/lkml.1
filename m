Return-Path: <linux-kernel-owner+w=401wt.eu-S1758436AbZAPBYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbZAPBYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbZAPBYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:24:09 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:23339 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbZAPBYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:24:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=QM9pa/l8KESfRPOVJ2183tzhK3oV1cpIlcMa9Ilc4DrqW4AEqRdAFmwkGQ/JtN9YOZ
         lhvRMnvCARlPm5VXdBhDi1/NjMvI/8HezISbJYGDL3lmvUW8PGGtdkDK1GTveqCjVV+f
         P2SMDjjEptaIONidcnJNCW/1loUZjqCYViKY8=
Date: Fri, 16 Jan 2009 10:24:03 +0900
From: Hitoshi Mitake <h.mitake@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-Id: <20090116102403.c04f2916.h.mitake@gmail.com>
In-Reply-To: <20081205005841.1ee1dc71.h.mitake@gmail.com>
References: <20081129192610.716a2d57.h.mitake@gmail.com>
	<20081129222449.e341f028.h.mitake@gmail.com>
	<20081129180144.GA15533@uranus.ravnborg.org>
	<20081130171604.dc3c8715.h.mitake@gmail.com>
	<20081130083700.GA31644@elte.hu>
	<20081130092407.GA10802@elte.hu>
	<20081201002056.d9f9204c.h.mitake@gmail.com>
	<20081130161504.GA25627@elte.hu>
	<a6b9f31a0812010551h28c0841fxa2a26af4645df64@mail.gmail.com>
	<20081201135922.GA30068@elte.hu>
	<a6b9f31a0812011558o373edbd3r9690efe539d43ca0@mail.gmail.com>
	<20081205005841.1ee1dc71.h.mitake@gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I wrote wrong mail address of LKML:-(
Resending, sorry.

On Fri, 5 Dec 2008 00:58:41 +0900
Hitoshi Mitake <h.mitake@gmail.com> wrote:

> On Tue, 2 Dec 2008 08:58:19 +0900
> "Hitoshi Mitake" <h.mitake@gmail.com> wrote:
> 
> > On Mon, Dec 1, 2008 at 22:59, Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > * Hitoshi Mitake <h.mitake@gmail.com> wrote:
> > >
> > >> On Mon, Dec 1, 2008 at 01:15, Ingo Molnar <mingo@elte.hu> wrote:
> > >> >
> > >> > * Hitoshi Mitake <h.mitake@gmail.com> wrote:
> > >> >
> > >> >> On Sun, 30 Nov 2008 10:24:07 +0100
> > >> >> Ingo Molnar <mingo@elte.hu> wrote:
> > >> >>
> > >> >> >
> > >> >> > the 32-bit build broke promptly - readq/writeq is a family of APIs that
> > >> >> > has to be either fully provided or not provided at all. The fix is below.
> > >> >>
> > >> >> Thanks for your fix and adding!
> > >> >> When will this patch be added to mainline?
> > >> >> I want to rewrite x38_edac.c to adapt new APIs.
> > >> >
> > >> > v2.6.29 at the earliest - if there are no regressions. A number of
> > >> > drivers use these APIs and usage is a bit messy - so bugs could be
> > >> > triggered, etc.
> > >> >
> > >> Thanks. What is URL of your repository?
> > >> I want to look your tree and test it.
> > >
> > > you can pick up tip/master via:
> > >
> > >  http://people.redhat.com/mingo/tip.git/README
> > >
> > 
> 

Ingo

I found that my previous patch contents wrong point, sorry.
Previous patch can't provide HAVE_READQ and HAVE_WRITEQ
to Kconfigs of other part well.

So I wrote a patch to fix this.
Please use.

Signed-off-by: Hitoshi Mitake <h.mitake@gmail.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 73f7fe8..6f1abcd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -19,8 +19,6 @@ config X86_64
 config X86
 	def_bool y
 	select HAVE_AOUT if X86_32
-	select HAVE_READQ
-	select HAVE_WRITEQ
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
@@ -1969,6 +1967,12 @@ config HAVE_ATOMIC_IOMAP
 	def_bool y
 	depends on X86_32
 
+config HAVE_READQ
+	def_bool y
+
+config HAVE_WRITEQ
+	def_bool y
+
 source "net/Kconfig"
 
 source "drivers/Kconfig"
