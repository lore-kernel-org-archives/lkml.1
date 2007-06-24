Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbXFXUbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbXFXUbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbXFXUbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:31:46 -0400
Received: from esuna.co.uk ([83.223.102.198]:56329 "EHLO mail.esuna.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751827AbXFXUbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:31:46 -0400
Message-ID: <467ED4A8.4080500@esuna.co.uk>
Date: Sun, 24 Jun 2007 21:31:36 +0100
From: "Jay L. T. Cornwall" <jay@esuna.co.uk>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Jay Cliburn <jacliburn@bellsouth.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc5: pdflush oops under heavy disk load
References: <467B12CA.5060405@esuna.co.uk>	<467BE118.4090308@redhat.com>	<467BE4F1.7040308@esuna.co.uk>	<467D0EB0.9030100@esuna.co.uk> <20070624125957.2e27820c@osprey.hogchain.net>
In-Reply-To: <20070624125957.2e27820c@osprey.hogchain.net>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:

>> The common factor here seems to be the buffer_head circular list
>> leading to invalid pointers in bh->b_this_page.
>>
>> I'm beginning to suspect the Attansic L1 Gigabit Etherner driver
>> (marked as EXPERIMENTAL in 2.6.22-rc5). I can't reproduce these
>> panics on disk-to-disk copies or SCP across the localhost interface.
>> However, SCP from a server onto either of two different HDDs hits
>> these oopses fairly quickly.

> How much RAM is installed in your machine?  If it's 4GB or more, does
> your problem go away if you boot with mem=3000M?

Intriguing. Yes, this machine has 4GB of RAM. If I boot with mem=3000M
the problem does indeed go away - I can't induce an oops even after
transferring tens of GB across the interface.

I'm not sure I follow why that would be the case, except that it relates
to pci_map_page behaviour. But I guess you have an inkling?

-- 
Jay L. T. Cornwall, http://www.esuna.co.uk/~jay/
PhD Student
Imperial College London
