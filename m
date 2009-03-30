Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbZC3B3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbZC3B3V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 21:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZC3B3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 21:29:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:41081 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZC3B3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 21:29:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=suIead5RQTfQmORS9tDmA/l9OnCvjGrzOU6dmbYsg96KYQXJFW0iJK1UjYSQoaIdNf
         tFbSzNrvT9XFdRrBItP1WVcNJuqxTlXcm4BPKYONR8qIPy5jfcpSt2Jm5gPZuIt81q2f
         Ib2WwonRl49NlQa86RKEJYT5UTTOnucRQS1H4=
MIME-Version: 1.0
In-Reply-To: <20090330003948.GA13356@mit.edu>
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
	 <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca>
	 <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>
	 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de>
	 <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed>
	 <20090330003948.GA13356@mit.edu>
Date: Sun, 29 Mar 2009 19:29:09 -0600
Message-ID: <9b1675090903291829u7a69df36m65b6698290773859@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: Trenton Adams <trenton.d.adams@gmail.com>
To: Theodore Tso <tytso@mit.edu>, Mark Lord <lkml@rtr.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 6:39 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Mon, Mar 30, 2009 at 10:14:51AM +1100, Dave Chinner wrote:
> All I can do is apologize to all other filesystem developers profusely
> for ext3's data=ordered semantics; at this point, I very much regret
> that we made data=ordered the default for ext3.  But the application
> writers vastly outnumber us, and realistically we're not going to be
> able to easily roll back eight years of application writers being
> trained that fsync() is not necessary, and actually is detrimental for
> ext3.
I am slightly confused by the "data=ordered" thing that everyone is
mentioning of late.  In theory, it made sense to me before I tried it.
 I switched to mounting my ext3 as ext4, and I'm still seeing
seriously delayed fsyncs.  Theodore, I used a modified version of your
fsync-tester.c to bench 1M writes, while doing a dd, and I'm still
getting *almost* as bad of "fsync" performance as I was on ext3.  On
ext3, the fsync would usually not finish until the dd was complete.

I am currently using Linus' tree at v2.6.29, in x86_64 mode.  If you
need more info, let me know.

tdamac ~ # mount
/dev/mapper/s-sys on / type ext4 (rw)

dd if=/dev/zero of=/tmp/bigfile bs=1M count=2000

Your modified fsync test renamed to fs-bench...
tdamac kernel-sluggish # ./fs-bench --sync
write (sync: 1) time: 0.0301
write (sync: 1) time: 0.2098
write (sync: 1) time: 0.0291
write (sync: 1) time: 0.0264
write (sync: 1) time: 1.1664
write (sync: 1) time: 4.0421
write (sync: 1) time: 4.3212
write (sync: 1) time: 3.5316
write (sync: 1) time: 18.6760
write (sync: 1) time: 3.7851
write (sync: 1) time: 13.6281
write (sync: 1) time: 19.4889
write (sync: 1) time: 15.4923
write (sync: 1) time: 7.3491
write (sync: 1) time: 0.0269
write (sync: 1) time: 0.0275
...

This topic is important to me, as it has been affecting my home
machine quite a bit.  I can test things as I have time.

Lastly, is there any way data=ordered could be re-written to be
"smart" about not making other processes wait on fsync?  Or is that
sort of thing only handled in the scheduler? (not a kernel hacker
here)

Sorry if I'm interrupting.  Perhaps I should even be starting another thread?
