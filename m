Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbZDQTi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbZDQTi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZDQTiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:38:18 -0400
Received: from n25.bullet.mail.mud.yahoo.com ([68.142.206.220]:32710 "HELO
	n25.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751095AbZDQTiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:38:18 -0400
X-Yahoo-Newman-Id: 90073.58624.bm@omp404.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zLdSqHjoZkrDuvAdgi2H+PNcJopzjAeSAPe777Py0p5EUb8jPzj/9b/S2v9a+ppq4lz9eniuTCyHfZ6ftIfUAGoR0XalxtN6hFZ4gWKnOE+EPGMxGJaFWn1vq7J+b9wOPeYDi1GN4fQJGfaxuXs9a7qazUTgiULCuuDCoqepJK4=  ;
X-YMail-OSG: cQGAKJAVM1lcP0EEbolHCSMC.0OPosxfc_o5fJ4pz_KG803vawWKwMf7iK5fVhyf.C21baz64lWjJoLw2JEqtl6uYTZHCwZ2jDHPk4T2T8Q7f_ChAUNrPGdG0DmsGjma1lIrCis3xyGizbf.rh85f8A43w316R1r_23L8.Qb2lSNO4R3w67ZVpM6P32VaJcVjdo9h_Y9Fym.9X46GKXbkVCf__UfbaDfoYSrXkcQzQnc_6nK.dtoRFhmnp7p_ZO0NkxeyLohR5BmHpD76mRxwmq1xvsrLt2d09SRLaDIwgY.PA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Kumar, Purushotam" <purushotam@ti.com>
Subject: Re: [PATCH 1/1] DaVinci: MMC: V4: MMC/SD controller driver for DaVinci family.
Date: Fri, 17 Apr 2009 12:38:14 -0700
User-Agent: KMail/1.9.10
Cc: davinci-linux-open-source@linux.davincidsp.com,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1238666196-29979-1-git-send-email-purushotam@ti.com> <20090410214143.4aa4045e@mjolnir.ossman.eu> <B85A65D85D7EB246BE421B3FB0FBB59301CCA0190F@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59301CCA0190F@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904171238.15077.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 April 2009, Kumar, Purushotam wrote:
> 
> > I'm still not following the requirements here. Why would the hardware
> > only need to have the FIFO primed for those two commands and not every
> > kind of write?
> 
> This required by SD controller as suggested by IP designer. Please
> look at SD controller spec at http://www.ti.com/litv/pdf/sprue30d .
> Please check section 3.2/3.6 and point no 11/10 in the controller spec.

Those are in Chapter 3, "Procedures for Common Operations" ...
that is, examples.  Examples, as a rule, are there just to
elaborate ("unpack") the more detailed text, not substitute
for clear specification.  (And TI is generally pretty good
about providing sane documentation, thank you!  Fewer problems
than with "some" vendors.)

In this case the spec says in a note in 2.7.2 that priming
the fifo is needed for "write transactions" ... since no
"fifo became empty" IRQ is generated.  It does not limit it
to the WRITE_BLOCK and WRITE_MULTIPLE_BLOCK commands.

Those examples are for writing single and multiple blocks; there
are no SDIO write operations shown, for example, or password
passing operations.  Those would also suffer from the lack of
a "fifo became empty" IRQ.


> It does not talk about priming by 32 bytes for any other command.

Said diffferently, *every* PIO write transaction shown primes
the fifo ... but there are no examples of non-block writes.


> This restriction is from SD controller.    

Could you confirm that interpretation with the folk who have
provided that silicon block?

If your reading is correct, and it's really a restriction to
those two commands, the documentation should change to say
that "single and multiple block write commands" require FIFO
priming ... not all "write transactions" as now written.

- Dave


