Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbYBERLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbYBERLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 12:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYBERL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 12:11:28 -0500
Received: from mosix1.rmnet.it ([82.145.99.230]:48496 "EHLO garbage.rmnet.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbYBERL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 12:11:27 -0500
User-Agent: Microsoft-Entourage/11.3.6.070618
Date: Tue, 05 Feb 2008 18:09:15 +0100
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux
 kernel
From: Matteo Tescione <matteo@rmnet.it>
To: FUJITA Tomonori <tomof@acm.org>, <mangoo@wpkg.org>
CC: <vst@vlnb.net>, <linux-scsi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <James.Bottomley@HansenPartnership.com>,
       <scst-devel@lists.sourceforge.net>, <akpm@linux-foundation.org>,
       <torvalds@linux-foundation.org>, <fujita.tomonori@lab.ntt.co.jp>
Message-ID: <C3CE56CB.57D4%matteo@rmnet.it>
Thread-Topic: [Scst-devel] Integration of SCST in the mainstream Linux
 kernel
Thread-Index: AchoGdXFFA2p6NQNEdyg7QAZ4zZdpQ==
In-Reply-To: <20080205223740L.tomof@acm.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-RMnet-garbage-MailScanner: Found to be clean
X-RMnet-garbage-MailScanner-SpamCheck: non spam,
	SpamAssassin (punteggio=-1.799, necessario 4.5, autolearn=not spam,
	ALL_TRUSTED -1.80, BAYES_50 0.00)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5-02-2008 14:38, "FUJITA Tomonori" <tomof@acm.org> wrote:

> On Tue, 05 Feb 2008 08:14:01 +0100
> Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> 
>> James Bottomley schrieb:
>> 
>>> These are both features being independently worked on, are they not?
>>> Even if they weren't, the combination of the size of SCST in kernel plus
>>> the problem of having to find a migration path for the current STGT
>>> users still looks to me to involve the greater amount of work.
>> 
>> I don't want to be mean, but does anyone actually use STGT in
>> production? Seriously?
>> 
>> In the latest development version of STGT, it's only possible to stop
>> the tgtd target daemon using KILL / 9 signal - which also means all
>> iSCSI initiator connections are corrupted when tgtd target daemon is
>> started again (kernel upgrade, target daemon upgrade, server reboot etc.).
> 
> I don't know what "iSCSI initiator connections are corrupted"
> mean. But if you reboot a server, how can an iSCSI target
> implementation keep iSCSI tcp connections?
> 
> 
>> Imagine you have to reboot all your NFS clients when you reboot your NFS
>> server. Not only that - your data is probably corrupted, or at least the
>> filesystem deserves checking...

Don't know if matters, but in my setup (iscsi on top of drbd+heartbeat)
rebooting the primary server doesn't affect my iscsi traffic, SCST correctly
manages stop/crash, by sending unit attention to clients on reconnect.
Drbd+heartbeat correctly manages those things too.
Still from an end-user POV, i was able to reboot/survive a crash only with
SCST, IETD still has reconnect problems and STGT are even worst.

Regards,
--matteo


