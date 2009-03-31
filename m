Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbZCaMfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbZCaMfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 08:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbZCaMfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 08:35:44 -0400
Received: from monster.nessie.de ([84.200.20.120]:53478 "EHLO
	monster.nessie.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZCaMfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:35:44 -0400
Message-ID: <49D20E1B.7010104@nessie.de>
Date: Tue, 31 Mar 2009 14:35:39 +0200
From: Michael Roth <mroth@nessie.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090321)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: petkovbb@gmail.com, petkovbb@googlemail.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Bug in 2.6.29 ide-cd: Kernel freeze: bisected + unacceptable
 workaround
References: <49CFCB2A.4020505@nessie.de>	<49CFEA24.10700@nessie.de>	<20090330072713.GA13776@liondog.tnic>	<200903302228.54601.bzolnier@gmail.com>	<20090331074508.GA16403@liondog.tnic> <20090331122820.167d52e5@the-village.bc.nu>
In-Reply-To: <20090331122820.167d52e5@the-village.bc.nu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> take it ok. Also, if I remember correctly, the original ide-cd behavior
>> was to issue the command and _then_ start DMA so we're back to that. I
>> guess now we should be concerned whether the other ATAPI devices can
>> handle the reverse situation where you first issue a command and _then_
>> start DMA.. Hmm...
> 
> Most devices don't care but you do need to follow the exact ATAPI spec.
> If you search way back through the archives you'll find long discussions
> on this during either 2.4 or 2.2 when HP hit problems caused by us
> turning DMA on too early.

AFAIK, the old bevavior was to start DMA _after_ issuing the command _only_
for CD-drives and for the remaining ide devices the other way around,
why not just restore the old behavior and do the DMA after command only
for CD-drives?


