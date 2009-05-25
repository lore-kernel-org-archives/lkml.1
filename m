Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZEYJuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZEYJuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 05:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbZEYJu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 05:50:26 -0400
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:45631 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754083AbZEYJuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 05:50:25 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 May 2009 05:50:25 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=H5irhQd2rBp+9m892lKGvObVU83y0g/yQ06+wR0FvqpYE+dJdJHmH2ZLCkSZtqssL02q81pGpTMKAQsuiOullUP4h3g/tnTxv9iKg9gRgZKtF471H7psTDnnSgspilfuPxb8G+Tb5riUjAl69N17RERyQwYsUiXM6++xU45xqw8=  ;
X-YMail-OSG: C6ZjumcVM1mZWBYFYRvlwGj5XOLSydW13JhrGi8pTWParknqo3TxFzw4s702dUxftz7UgEL4YOUQ8U7jq1_u3_Q3RPIa3rEpbVUiFaCHCULdjDyVZ9zzvnz6M3YP1aBQIR6YQo_bHTDd4evr15dsZ.GE31cfcc2tRO0LL8O7Kd6aSxj34Io2jYepOCN_UkCqPkp3Vk17w9WVj4vonTUIU13QbPLS4XUZpr25geP4DTg157ONIMMCgEl2Mz1CCQNKhDdOb2Ass8FeOfQ-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Date: Mon, 25 May 2009 02:43:46 -0700
User-Agent: KMail/1.9.10
Cc: "Pierre Ossman" <pierre@ossman.eu>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200905201902.51377.david-b@pacbell.net> <200905251104.47550.wolfgang.mues@auerswald.de>
In-Reply-To: <200905251104.47550.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200905250243.46984.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 May 2009, Wolfgang Mües wrote:
> Can someone please explain for me the purpose and the implementation of this 
> wear level logic in block.c?

I think you're misinterpreting what I said.  The wear leveling
logic is in the microcontroller *INSIDE THE MMC/SD DEVICE* not
on the Linux side driver.


> I can not see why a sector erase and the sector erase result codes of a MMC/SD 
> card can be used to get any usefull information about wear leveling in the 
> card. The mapping of physical to logical blocks is not reported by the card, 
> and the number of erase cycles for each block is also not reported. SO how 
> can the host be able to optimize the wear leveling?

It can't.  But when the card controller knows that for example
certain logical blocks are not holding data, it can use that
for wear leveling ... it's got more physical blocks to use to
even out the writes, as well as having any records it kept on
writes, reads, and erasures.



