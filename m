Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbYGVTQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbYGVTQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbYGVTQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:16:27 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:36737 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbYGVTQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:16:26 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: pata_it821x completely broken
Date: Tue, 22 Jul 2008 21:16:17 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
References: <200807042153.56644.linux@rainbow-software.org> <200807221959.53669.linux@rainbow-software.org> <20080722191022.0417f45c@lxorguk.ukuu.org.uk>
In-Reply-To: <20080722191022.0417f45c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807222116.19077.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008 20:10:22 Alan Cox wrote:
> > New patch below, this time with DMA forced on RAID volumes - as my
> > firmware does not identify the RAID arrays as DMA capable :(
>
> The underlying problem is that the newer libata rewrites the dev->id data
> in ways that we can't then patch up. I've actually been hacking on this a
> bit today. The existing it821x code was working fine and it does the
> needed patching, it just needs to do it in a different place, and that in
> turn needs a new ap->ops->read_id() method so it can be hooked.

I can test the code once it's done.
I just moved my / to the RAID1 provided by IT8212. The controller has a great 
feature that allows converting a drive between RAID1/standalone without data 
loss (haven't seen anything like this yet). Also the background rebuild is 
nice (as seen on much more expensive RAID controllers), it's running as I'm 
typing this.

>
> On the bright side that also allows us to implement a pata_mfm/rll
> driver at last.
>

I used to have an old drive that was something like that - 5.25" Seagate 40MB 
drive. I sold it including the controller a couple of years ago (it was still 
working) so no testing fun for me.

> Alan



-- 
Ondrej Zary
