Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbZBHTtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbZBHTtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 14:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZBHTtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 14:49:09 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:48795 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753245AbZBHTtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 14:49:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=hZdiscumPOF1K4WlEcOoQLK40+KAjOelrBLvtbznMf3dLyWn+ZZkjlOfB+pgquybbHYntpfrpFzplSna1UY4NKm0NiiviJetfttX6r5OZoaCfjEEoRnHEqbwLZdKKVLhsTsN4iyXJXrBJ0bAXc0mceTFu7k5fI1o0HAaQla7BBk=  ;
X-YMail-OSG: Lbal.FAVM1lNsKUroVNDW.TpbegsJeTv0cPxRP1402E2Ss7erC.73If81.pXd8qIw.YWwmkoboKjAmRjIyJn6TeJrEmf7j7Ha0Zp4ZqQFg1AN5FogUMoBOb_7gb3nduPVCxmVcnsmYwes9U8p.U3_5lC
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH E 10/14] OMAP clock: support "dry run" rate and parent changes
Date: Sun, 8 Feb 2009 11:48:58 -0800
User-Agent: KMail/1.9.10
Cc: Paul Walmsley <paul@pwsan.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>
References: <20090128192551.29333.82943.stgit@localhost.localdomain> <20090128192753.29333.56931.stgit@localhost.localdomain> <20090208131734.GA21434@n2100.arm.linux.org.uk>
In-Reply-To: <20090208131734.GA21434@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902081148.59158.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 February 2009, Russell King - ARM Linux wrote:
> A far better way to approach this would be to split the set_rate/recalc
> functionality into two parts:
> 
> 1. a method which returns the both the new clock rate and the hardware
>    programming information
> 2. a method to commit the hardware programming information to the registers

Much simpler to just pass a "commit" flag and not
try to come up with some generic way to represent
"hardware programming information"; in general that
will be very different between clocks.

Then clk_round_rate() passes "false" for commit,
while clk_set_rate() passes "true".  And in both
cases the value returned is the rate, or negative
errno to indicate a fault.

- Dave
