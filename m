Return-Path: <linux-kernel-owner+w=401wt.eu-S1761006AbZDGWo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761006AbZDGWo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 18:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbZDGWoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 18:44:19 -0400
Received: from n16a.bullet.mail.mud.yahoo.com ([68.142.207.126]:49124 "HELO
	n16a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754615AbZDGWoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 18:44:19 -0400
X-Yahoo-Newman-Id: 566898.45730.bm@omp414.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JNneuv3OpprYyiULBwYXaqAIqVItYUMq+Jj9rlnpVB4IIivD5+kRHfgNm99BVjS7OzIrXXm2okRPhCBScAMm7F4Gxt8X0Akpo/bmpwLKEZYzIkYnEC55gFa3toJ/mGRy+77bI52TJPwEhyiQ4DYohuEh0di3dIl+paLr/bvKgc4=  ;
X-YMail-OSG: ZkUXDrwVM1nmkiAAynvlAnj4iZc.oF5Jc1TP9pjInhEkEL2zf4GFKSGTDvAB5ex0_2W4CV3RrxH6NRkP0S5QBSryskGWSMsS5NfcvdwJR.wQwRc6j_8ZGBUY.NMF2tB_cOzsQ4M8hbVNdZ47S.squJPq_aA4VxZ32riSeXdmBfmO8ZhBuCIQyq5XHtRJw8LdmerzXewX1vRVyM.fd.eV9RJs9USBR.tsG9_nA33PFj60d0tRdh27EjZUea6XpF85SRF3ymTOhOWw3fUmRoPrOvXuD4HcVZjzWDCJ6zgiTVxFwsWe
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] MTD-NAND: Changes to read_page APIs to support NAND_ECC_HW_SYNDROME mode on TI DaVinci DM355
Date: Tue, 7 Apr 2009 15:44:15 -0700
User-Agent: KMail/1.9.10
Cc: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1238601784-9563-1-git-send-email-nsnehaprabha@ti.com> <200904061849.23110.david-b@pacbell.net> <7A436F7769CA33409C6B44B358BFFF0CFFAA90C0@dlee02.ent.ti.com>
In-Reply-To: <7A436F7769CA33409C6B44B358BFFF0CFFAA90C0@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904071544.15558.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, Narnakaje, Snehaprabha wrote:
> 
> > > > If your device does not do that or you do not want to utilize it for
> > > > whatever reasons then just use the NAND_ECC_HW mode which lets you
> > > > place your ECC data where ever you want.
> > 
> > And that's exactly what these patches do:  enable just such choices.
> > The $SUBJECT patch would be needed to use NAND_ECC_HW with this 4-bit
> > ECC hardware, and not be forced to "choose" the infix-OOB policy.
> 
> I had looked read_page/write_page APIs of the NAND_ECC_HW mode to see
> if we can use this mode for DaVinci DM355 device. 
> 
> The read_page handler for NAND_ECC_HW mode reads the data and ECC from
> hardware for each chunk. It then reads the OOB and extracts ecc code
> from it, before using the ECC from hardware and ecc code from OOB for
> data correction.   

That's pretty much what the RFC patches I sent about 2 months ago
were doing.  One "RFC" aspect was very much whether there wasn't
a better option than "infix OOB".  Overview of the patches and test
results:

  http://linux.omap.com/pipermail/davinci-linux-open-source/2009-February/010977.html

The patches won't quite apply to the version of the DaVinci NAND
driver now in mainline, but they've had only minor changes since then:

  http://linux.omap.com/pipermail/davinci-linux-open-source/2009-February/010979.html
	Adds basic 4-bit ECC support to the DaVinci NAND driver using
	HW_SYNDROME, but limited to single ECC step (small page NAND).

  http://linux.omap.com/pipermail/davinci-linux-open-source/2009-February/010976.html
	Now in mainline ... fixes NAND-core data corruption caused
	by using HW_SYNDROME with multi-step ECC.

  http://linux.omap.com/pipermail/davinci-linux-open-source/2009-February/010978.html
	Updates that 4-bit ECC support to work with multi-step ECC,
	but *strongly* restricted to something else writing the BBT.

Since then I haven't put any more work into sorting out where the
u-boot failure and oob/subpage test failures came from.  That stuff
was not tested with 4KB pages either ... there's at least one bug
in the NAND core code that Sneha pointed out.

(Thomas, the discussion thread for the second of those patches has
more background if you're interested and have the time.)


> The read_page/write_page APIs for NAND_ECC_HW_SYNDROME have the other
> problem that David mentioned - overwriting NAND manufacturers bad block
> meta data, when used with large page NAND chips.

The third patch above goes to some length to prevent Linux from
doing anything other than taking a BBT from flash that something
else has written.  So long as nothing trashes that BBT, and there's
a nice way to get it written in the first place (u-boot need not
apply, it'll have the same issues as Linux), things might act
OK -- once someone resolves the failures I observed.  Still seems
undesirably (and needlessly) fragile to me.

And I rather suspect that fragility is the reason the ROM boot
loader in newer chip revisions from TI is avoiding "infix OOB".
Plus likely a bit of feedback from their development partners
who package end-product NAND programming solutions ... I'm just
guessing, but it sure seems to me like there are many reasons
to avoid that "infix OOB" fragility.

- dave

