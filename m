Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbXLASe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbXLASe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 13:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbXLASd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 13:33:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39588 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbXLASd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 13:33:57 -0500
Date: Sat, 1 Dec 2007 19:32:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Mark Lord <lkml@rtr.ca>, Pavel Machek <pavel@ucw.cz>,
       Mark Lord <liml@rtr.ca>, Thomas Gleixner <tglx@linutronix.de>,
       len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
Message-ID: <20071201183256.GA14052@elte.hu>
References: <20071115181418.GA6603@ucw.cz> <473C825E.3030307@rtr.ca> <20071115193424.GA31691@elte.hu> <20071115193612.GA751@elte.hu> <20071130125628.GA30773@lazybastard.org> <20071130133546.GB29679@elte.hu> <20071130134312.GA32273@elte.hu> <20071130183510.GA1570@lazybastard.org> <20071130184625.GB9928@elte.hu> <20071201151650.GA5031@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071201151650.GA5031@lazybastard.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jörn Engel <joern@logfs.org> wrote:

> > hm, that looks weird. if you disable CONFIG_PROVE_LOCKING, does that 
> > improve things? (or just turns a noisy lockup into a silent lockup?)
> 
> Not much, although the dumps look different now:
> http://logfs.org/~joern/trace3.jpg
> http://logfs.org/~joern/trace4.jpg
> 
> I have to change my qemu setup a little to see the top of those 
> dumps...

btw., if you start qemu like this:

qemu -cdrom ./cdrom.iso -hda ./hda.img -boot c -full-screen -kernel 
~/bzImage -append "root=/dev/hda1 earlyprintk=serial,ttyS0,9600 
console=tty console=ttyS0,9600 enforcing=0 debug"

you'll get the inner kernel's serial console log to qemu's standard 
output. Pretty useful for capturing kernel crashes.

	Ingo
