Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbZL3N3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbZL3N3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 08:29:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZL3N3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 08:29:04 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:35425 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbZL3N3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 08:29:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Wg4jft1EmIdjL8yzTkeyki6gwnkqlNj9v/cGe+71G9I/TUioIcDZP6qlCFs4o/Vktl
         jun69rnwsjUYniOP2W/Aqginltupt1sW7YubQiNIV0Eryw47FOOlZicRoJ13O3bBN6/S
         4mt+i/YhI66o5TZMgWr1pyUgvthmB9JQXCVwg=
MIME-Version: 1.0
In-Reply-To: <20091230061955.GI2186@core.coreip.homeip.net>
References: <b9df5fa10912282009x5d0d2de4q36ab8a1f29d5a7de@mail.gmail.com>
	 <20091230061955.GI2186@core.coreip.homeip.net>
Date: Wed, 30 Dec 2009 19:29:01 +0600
Message-ID: <b9df5fa10912300529i136c11daicc159a25795f8c2c@mail.gmail.com>
Subject: Re: [PATCH] input, mouse: Change the prototype of functions in 
	lifebook.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alessandro Rubini <rubini@vision.unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/09, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
>
> I suppose it is CONFIG_DMI, not CONFIG_PM... In fact, we should simply
>  make this driver depend on CONFIG_DMI.

Oh.. yes. I made a stupid mistake. Please checkout the following patch.

-------

 input, mouse: Make lifebook mouse driver depend on CONFIG_DMI.

When CONFIG_DMI=n, then we are warned by the following warning:

drivers/input/mouse/lifebook.c:33: warning: 'lifebook_limit_serio3'
defined but not used
drivers/input/mouse/lifebook.c:41: warning: 'lifebook_set_6byte_proto'
defined but not used

We need to make this driver depend on CONFIG_DMI.



Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus/drivers/input/mouse/Kconfig	2009-12-28 12:37:51.000000000 +0600
+++ rakib/drivers/input/mouse/Kconfig	2009-12-30 20:24:31.000000000 +0600
@@ -70,7 +70,7 @@ config MOUSE_PS2_SYNAPTICS
 config MOUSE_PS2_LIFEBOOK
 	bool "Fujitsu Lifebook PS/2 mouse protocol extension" if EMBEDDED
 	default y
-	depends on MOUSE_PS2 && X86
+	depends on MOUSE_PS2 && X86 && DMI
 	help
 	  Say Y here if you have a Fujitsu B-series Lifebook PS/2
 	  TouchScreen connected to your system.
