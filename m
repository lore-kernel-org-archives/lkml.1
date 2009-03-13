Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbZCMHlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbZCMHlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbZCMHlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:41:24 -0400
Received: from web4108.mail.ogk.yahoo.co.jp ([124.83.200.70]:23375 "HELO
	web4108.mail.ogk.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751019AbZCMHlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:41:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Message-ID:Received:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=icsB2d4BPJW4N5sT/LrwU9RyM6H9QhaJqgn2LHJsUyrHbX4T9y2o1vjYCrbTc8LYhHtqn3OYCh2NFnjCqWfmx7HaifGZn6nBM04pgvMuDIinp2qFpHvZBmTLMJeJ2c0c  ;
Message-ID: <20090313074120.48682.qmail@web4108.mail.ogk.yahoo.co.jp>
Date: Fri, 13 Mar 2009 16:41:19 +0900 (JST)
From: Norman Diamond <n0diamond@yahoo.co.jp>
Reply-To: n0diamond@yahoo.co.jp
Subject: Re: Off-by-one in both LIBATA and IDE drivers
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: Jim Paris <jim@jtan.com>, Robert Hancock <hancockrwd@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <liml@rtr.ca>,
       n0diamond@yahoo.co.jp
In-Reply-To: <20090312230230.95814.qmail@web4110.mail.ogk.yahoo.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LIBATA with the patch to ata.h now handles all sectors on
hard drives that it recognizes.

An example of a hard drive that it recognizes is one that
is attached to an Intel ICH7M chipset when hda=noprobe
hdc=noprobe have been specified in the boot command.

An example of a hard drive that it doesn't recognize is
one that is attached to an Intel PIIX4 chipset when
hda=noprobe hdc=noprobe have been specified in the boot
command.

In either case, the boot parameters persuade the old IDE
drivers not to grab the controllers.

With ICH7M, LIBATA takes over and runs both the hard drive
and DVD at full speed.

With PIIX4, LIBATA initializes.  End of story.  Slax can't
find its own CD.  If I only use hda=noprobe then the old
IDE controller assigns hdc to the CD and Slax finds it,
but the hard drive is still undetected.  Behaviour is the
same under VMware as in a genuine old PC.

LIBATA's PIIX drivers are built in along with everything
else.  They just seem not to get executed.

What am I missing?

--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
