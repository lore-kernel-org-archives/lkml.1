Return-Path: <linux-kernel-owner+w=401wt.eu-S965417AbXBFUlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965417AbXBFUlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965433AbXBFUlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:41:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:44003 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965417AbXBFUlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:41:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=GdW58w+JK51gVYEC9siM6gcNwL4EplpyYKSMm1sDhaBRqhZ/O44TgFoKfX4uZ68K95jzdb3NnkQqs+3elo3/ciikWeqZQ892xqpY4X1UT2UaWVKeg+mV9y+Z/dCLYgrmjZpcc6/OJnfcualDhxoWsuaOPf9bRXWR7UfNkH7kPcg=
Date: Tue, 6 Feb 2007 22:41:30 +0200
To: Joe Perches <joe@perches.com>
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH 2.6.20] isdn-capi: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206204130.GU8991@Ahmed>
References: <20070206160446.GE8991@Ahmed> <1170784337.3688.18.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170784337.3688.18.camel@localhost>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 09:52:17AM -0800, Joe Perches wrote:
> On Tue, 2007-02-06 at 18:04 +0200, Ahmed S. Darwish wrote:
> > A patch to use ARRAY_SIZE macro already defined in kernel.h
> > Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
[...]
> > -    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
> > +    int nelem = ARRAY_SIZE(procfsentries);
> >      int i;
> >  
> >      for (i=0; i < nelem; i++) {
> 
> For these patches, perhaps you can eliminate the temporary
> variable and change the loop to the more common form of
> 
> 	for (i = 0; i < ARRAY_SIZE(array); i++) {

Thanks, I think it's better too. Here's the modified patch.

A patch to use ARRAY_SIZE macro when appropriate.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index d22c022..87fe89c 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1456,10 +1456,9 @@ static struct procfsentries {
 
 static void __init proc_init(void)
 {
-    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
     int i;
 
-    for (i=0; i < nelem; i++) {
+    for (i = 0; i < ARRAY_SIZE(procfsentries); i++) {
         struct procfsentries *p = procfsentries + i;
 	p->procent = create_proc_entry(p->name, p->mode, NULL);
 	if (p->procent) p->procent->read_proc = p->read_proc;
@@ -1468,10 +1467,9 @@ static void __init proc_init(void)
 
 static void __exit proc_exit(void)
 {
-    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
     int i;
 
-    for (i=nelem-1; i >= 0; i--) {
+    for (i = ARRAY_SIZE(procfsentries) - 1; i >= 0; i--) {
         struct procfsentries *p = procfsentries + i;
 	if (p->procent) {
 	   remove_proc_entry(p->name, NULL);
diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index c4d438c..cff5d1e 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -2218,10 +2218,9 @@ static struct procfsentries {
 
 static void __init proc_init(void)
 {
-    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
     int i;
 
-    for (i=0; i < nelem; i++) {
+    for (i = 0; i < ARRAY_SIZE(procfsentries); i++) {
         struct procfsentries *p = procfsentries + i;
 	p->procent = create_proc_entry(p->name, p->mode, NULL);
 	if (p->procent) p->procent->read_proc = p->read_proc;
@@ -2230,10 +2229,9 @@ static void __init proc_init(void)
 
 static void __exit proc_exit(void)
 {
-    int nelem = sizeof(procfsentries)/sizeof(procfsentries[0]);
     int i;
 
-    for (i=nelem-1; i >= 0; i--) {
+    for (i = ARRAY_SIZE(procfsentries) - 1; i >= 0; i--) {
         struct procfsentries *p = procfsentries + i;
 	if (p->procent) {
 	   remove_proc_entry(p->name, NULL);


-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
