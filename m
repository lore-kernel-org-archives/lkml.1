Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZK3Mfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZK3Mfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 07:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbZK3Mft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 07:35:49 -0500
Received: from web37604.mail.mud.yahoo.com ([209.191.87.87]:20267 "HELO
	web37604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751867AbZK3Mfs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 07:35:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=JO2LLmTytR9US/7SArOw/2otprtL4FPh5+lrFYMW/6nSExpaBMVD3VaVJivv68rGhtwTFiP5FtuQZ0lbAcNJWSo2bkheQJ/OLCOcXo1pG49J8i4w39F/43d5zhUB069r3t81thf0EDK812xSDT4qaYfiMQBx7Ls47q9hXKG6le8=;
Message-ID: <109361.10237.qm@web37604.mail.mud.yahoo.com>
X-YMail-OSG: g9HnYqsVM1m9OZcge5vZA9VUxL7u8Mk6YADU_sWMnuzMBV96.rvcrsmMxQStE.274cV002SroD6y6gydMsJq1dXh6WOs4bHeg.14OTBLEq_WeFYYhwrHuSBNYltSIt2r8QvumtAaUadcNFhOpwKj4e9osgL75i4DjJ9.5I6SAqwxBGMm6pK4sXPMSxt9VbQhL6FsDri1zu3G3RGYo39Sy.zPbzsKIhfTksQnanG2pXBjt7TttVzTRGdi6kLLa7i0Dwdb3H8coTPuKbYRK36reVZ7tq4gQ_ZCVNXwWDaOOYutijAqkHj26VKvJXhWNWVlpEsjTlOhC1PP4u9j5wLE948CsNKMTCi.NDZtGZkz0qg4TVOLNs2k9CXowVVSayRbBMhDnkr71RvL5_vGKjiPrTo0gxzdKnvXkbeHGebeKNiAMyrQgJ5ON_fKXwxdvG2.tT30MvYx_Ob53OSy0vMAQt3HxMlikA8L2rkC9gMDYU6LVC87_oS3FdoESAzQ
X-Mailer: YahooMailClassic/8.1.6 YahooMailWebService/0.8.100.260964
Date: Mon, 30 Nov 2009 04:35:54 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: XD/smartmedia - how to implement it right?
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: =?iso-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, arnd@arndb.de,
       tglx@linutonix.de
In-Reply-To: <1259404599.15208.6.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sat, 11/28/09, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: Re: XD/smartmedia - how to implement it right?
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Jörn Engel" <joern@logfs.org>, "linux-kernel" <linux-kernel@vger.kernel.org>, arnd@arndb.de, tglx@linutonix.de
> Date: Saturday, November 28, 2009, 2:36 AM
> On Fri, 2009-11-27 at 23:22 -0800,
> Alex Dubov wrote: 
> > > 
> > > The "mtd uses blocking calls" argument I can
> help
> > > with.  For some other
> > > project I've added non-blocking calls to mtd[1].
> > > 
> > > Biggest problems I see are a) the userspace
> interface and
> > > b) allowing
> > > both raw flash access through MTD and block
> device access
> > > with an FTL.
> > > 
> > > [1] http://lists.infradead.org/pipermail/linux-mtd/2009-November/028065.html
> > > 
> > > Jörn
> > 
> > I actually tried several approaches to this problem
> and I think, I have a good idea about how to create a fully
> asynchronous mtd driver, which can handle different device
> models. Unfortunately, I had other commitments so I couldn't
> advance my mtd stuff.
> > 
> > Recently I was going to go back to it, but then I was
> asked to implement some additional functionality in rapidio
> subsystem, which I'll have to take care of first.
> 
> Hi, 
> 
> First of all, thank you very much for your contributions.
> Could you explain, why we need an asynchronous mtd driver?

Because it's the future. ;-)

> 
> Also, as I understand the command interface more and more,
> it seems that
> 'magically' xD card had same interface as standard NAND
> flash chip.
> 
> I think I can implement the driver for each controller just
> like an nand
> chip driver.
> 

xD spec, first of all, is about flash-based ordinary block devices.
All the hard problems are in good r/w FTL implementation, which is
currently mostly absent from the MTD.



      
