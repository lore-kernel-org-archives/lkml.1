Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbZKICGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbZKICGn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 21:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZKICGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 21:06:43 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:61852 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZKICGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 21:06:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GIVkJYwiUKMHSCrp0BAxBqcEJG0nfbUpa17A+Eo2heC8mmod5OyPdsHRIEzNFvrG+u
         HfJA6wXc+nkL1lDwCQ8HkB5dClM97f+4t7W3MMxZmx4VOEp0bRpl/mnfi0jOdoWsQF0r
         fEgS3sPFoSuxFXfOJihzjvJGp/JV3HyOyFUT4=
MIME-Version: 1.0
In-Reply-To: <4AF54B77.2000605@gmail.com>
References: <b9df5fa10911022029q197a0c5dkbbda609f4e41287@mail.gmail.com>
	 <b9df5fa10911062108l2334be64ka0777e89c6dbc17f@mail.gmail.com>
	 <4AF54B77.2000605@gmail.com>
Date: Mon, 9 Nov 2009 08:06:47 +0600
Message-ID: <b9df5fa10911081806m7564f778k35e0308fc5ddfba4@mail.gmail.com>
Subject: Re: [PATCH -mm] char, moxa: Make isabrds variable global.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/09, Jiri Slaby <jirislaby@gmail.com> wrote:
>
> Sorry I had no time to look into the first patch. And it makes no sense.
>  The driver is unusable on !MODULE && !PCI. So better fix is to disallow
>  whole build on such configurations. Care to fix that?
>
Hi Jiri, thanks for your care. Would you please checkout the
patch below? Is it okay?


 moxa:  Disallow moxa build when !MODULE && !PCI.
If MODULES support is not enabled then MODULE=y is not
possible.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
-----

--- linus/drivers/char/Kconfig	2009-11-06 13:45:42.000000000 +0600
+++ rakib/drivers/char/Kconfig	2009-11-08 21:31:48.000000000 +0600
@@ -216,7 +216,7 @@ config ESPSERIAL

 config MOXA_INTELLIO
 	tristate "Moxa Intellio support"
-	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
+	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI) || MODULES
 	select FW_LOADER
 	help
 	  Say Y here if you have a Moxa Intellio multiport serial card.
@@ -226,7 +226,7 @@ config MOXA_INTELLIO

 config MOXA_SMARTIO
 	tristate "Moxa SmartIO support v. 2.0"
-	depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA)
+	depends on SERIAL_NONSTANDARD && (PCI || EISA || ISA) || MODULES
 	help
 	  Say Y here if you have a Moxa SmartIO multiport serial card and/or
 	  want to help develop a new version of this driver.
