Return-Path: <linux-kernel-owner+w=401wt.eu-S1760819AbZF2QBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760819AbZF2QBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759509AbZF2QBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:01:10 -0400
Received: from mail.open.by ([193.232.92.17]:55724 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758883AbZF2QBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:01:09 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8863 [Jun 29 2009]
X-SpamTest-Info: helo_type=3
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Info: {UDS BL}
X-SpamTest-Method: probable
X-SpamTest-Rate: 65
X-SpamTest-SPF: softfail
X-SpamTest-Status: Probable Spam
X-SpamTest-Status-Extended: probable_spam
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Mon, 29 Jun 2009 19:02:35 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13522] BUG: scheduling while atomic
Message-ID: <20090629160235.GA3461@localdomain.by>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
 <6JJ2m5kyucK.A.D2D.VJASKB@chimera>
 <20090629154119.2c61f234@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629154119.2c61f234@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/29/09 15:41), Alan Cox wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> 
> Yes although getting people seeing to test with might_sleep() checks in
> the tty layer demonstrate the tty layer isn't calling into ppp with irqs
> disabled when it shouldn't so I'm at a loss as to whether this is a
> network bug, a scheduler bug or something else.

Looks like I can't reproduce with rc1-git5 (after several hours)...
I'll try -git3,-git4.

> 
> The schedule error in __tasklet_schedule() is itself rather peicular.
> 


Reported	: 2009-06-28 22:07 by Rafael J. Wysocki
Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13652
Subject         : scheduling while atomic: pptpgw

Rafael, I'm not sure we need 'scheduling while atomic: pptpgw' bug.
Initially BUG 13522 was named "BUG: scheduling while atomic: pptpgw" 
and renamed to "BUG: scheduling while atomic" since I was not sure wheter this is ppp or scheduler bug...

---
kernel: [ 1424.347514] BUG: scheduling while atomic: ksoftirqd/0/4/0x10000500
kernel: [27404.945372] BUG: scheduling while atomic: pptpgw/4637/0x00000400
kernel: [ 1715.273674] BUG: scheduling while atomic: ksoftirqd/0/4/0x10000500
kernel: [ 1631.073371] BUG: scheduling while atomic: pptpgw/3169/0x10000500
...
---

	Sergey
