Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbYHKPpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbYHKPpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYHKPpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:45:44 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:48574 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYHKPpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:45:43 -0400
Message-ID: <48A05EB1.3050508@keyaccess.nl>
Date: Mon, 11 Aug 2008 17:45:53 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@osdl.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kill arch/x86/kernel/mpparse.c debugging printk.
References: <489C77C6.7040408@keyaccess.nl> <20080811122038.GA10082@elte.hu> <48A05E79.4030304@keyaccess.nl>
In-Reply-To: <48A05E79.4030304@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------090202020700090408030502"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090202020700090408030502
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 11-08-08 17:44, Rene Herman wrote:

> One problem; on 32-bit, "apic=" is a __setup() param and isn't actually 
> early enough for us here so this needs it turned into an early_param() 
> (followup).

Ie:

Rene.

--------------090202020700090408030502
Content-Type: text/plain;
 name="0002-x86-make-apic-an-early_param-on-32-bit.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-x86-make-apic-an-early_param-on-32-bit.patch"

>From 9655f5ab2537ecd5c5d92b03840f3b6aeed441ad Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Mon, 11 Aug 2008 17:35:41 +0200
Subject: [PATCH] x86: make "apic" an early_param() on 32-bit

On 32-bit, "apic" is a __setup() param meaning it is parsed rather
late in the game. Make it an early_param() for apic_printk() use
by arch/x86/kernel/mpparse.c.

On 64-bit, it already is an early_param().

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 arch/x86/kernel/apic_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index d6c8983..f432d48 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -1726,9 +1726,9 @@ static int __init apic_set_verbosity(char *str)
 		apic_verbosity = APIC_DEBUG;
 	else if (strcmp("verbose", str) == 0)
 		apic_verbosity = APIC_VERBOSE;
-	return 1;
+	return 0;
 }
-__setup("apic=", apic_set_verbosity);
+early_param("apic", apic_set_verbosity);
 
 static int __init lapic_insert_resource(void)
 {
-- 
1.5.5


--------------090202020700090408030502--
