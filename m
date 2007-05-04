Return-Path: <linux-kernel-owner+w=401wt.eu-S1031275AbXEDWnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031275AbXEDWnD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 18:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031442AbXEDWnC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 18:43:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58802 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031275AbXEDWnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 18:43:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] PM: Separate hibernation code from suspend code
Date: Sat, 5 May 2007 00:47:24 +0200
User-Agent: KMail/1.9.5
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
References: <200705041132.32227.rjw@sisk.pl> <a781481a0705041022jdc163fg20882d450338fb53@mail.gmail.com>
In-Reply-To: <a781481a0705041022jdc163fg20882d450338fb53@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705050047.25517.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 4 May 2007 19:22, Satyam Sharma wrote:
> Trivial suggestions:
> 
> On 5/4/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > --- linux-2.6.21.orig/include/linux/suspend.h   2007-05-02 22:08:58.000000000 +0200
> > +++ linux-2.6.21/include/linux/suspend.h        2007-05-03 15:22:24.000000000 +0200
> > [...]
> > +/**
> > + * hibernation_set_ops - set the global hibernate operations
> > + * @ops: the hibernation operations to use in subsequent hibernation transitions
> > + */
> > +extern void hibernation_set_ops(struct hibernation_ops *ops);
> 
> Comment must go near code, not with prototype in header.
> 
> > +/**
> > + * hibernate - hibernate the system
> > + */
> > +extern int hibernate(void);
> 
> Pointless comment. You've already written a doc-book comment in the
> code for this function anyway, so could just as well remove this.

The appended patch fixes these problems.

Greetings,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Remove unnecessary comments in include/linux/suspend.h and  add a comment
describing hibernation_set_ops() in kernel/power/disk.c .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/suspend.h |    8 --------
 kernel/power/disk.c     |    5 +++++
 2 files changed, 5 insertions(+), 8 deletions(-)

Index: linux-2.6.21/include/linux/suspend.h
===================================================================
--- linux-2.6.21.orig/include/linux/suspend.h	2007-05-05 00:39:53.000000000 +0200
+++ linux-2.6.21/include/linux/suspend.h	2007-05-05 00:43:39.000000000 +0200
@@ -58,15 +58,7 @@ extern void swsusp_set_page_free(struct 
 extern void swsusp_unset_page_free(struct page *);
 extern unsigned long get_safe_page(gfp_t gfp_mask);
 
-/**
- * hibernation_set_ops - set the global hibernate operations
- * @ops: the hibernation operations to use in subsequent hibernation transitions
- */
 extern void hibernation_set_ops(struct hibernation_ops *ops);
-
-/**
- * hibernate - hibernate the system
- */
 extern int hibernate(void);
 #else
 static inline void register_nosave_region(unsigned long b, unsigned long e) {}
Index: linux-2.6.21/kernel/power/disk.c
===================================================================
--- linux-2.6.21.orig/kernel/power/disk.c	2007-05-05 00:40:02.000000000 +0200
+++ linux-2.6.21/kernel/power/disk.c	2007-05-05 00:43:32.000000000 +0200
@@ -47,6 +47,11 @@ enum {
 
 struct hibernation_ops *hibernation_ops;
 
+/**
+ * hibernation_set_ops - set the global hibernate operations
+ * @ops: the hibernation operations to use in subsequent hibernation transitions
+ */
+
 void hibernation_set_ops(struct hibernation_ops *ops)
 {
 	if (ops && !(ops->prepare && ops->enter && ops->finish)) {
