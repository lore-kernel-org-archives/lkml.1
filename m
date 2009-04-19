Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbZDSXlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbZDSXlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 19:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbZDSXlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 19:41:42 -0400
Received: from rtr.ca ([76.10.145.34]:53914 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZDSXll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 19:41:41 -0400
Message-ID: <49EBB6B4.6090507@rtr.ca>
Date: Sun, 19 Apr 2009 19:41:40 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: =?UTF-8?B?Um9nw6lyaW8gQnJpdG8=?= <rbrito@ime.usp.br>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: Quick question about libata and hdparm
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <49EB1A33.7050808@rtr.ca> <20090419200303.GA2891@ime.usp.br>
In-Reply-To: <20090419200303.GA2891@ime.usp.br>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rogério Brito wrote:
> On Apr 19 2009, Mark Lord wrote:
..
>> The -m flag could be done, and I even have code in hdparm to do it,
>> but libata is very buggy with multi-sector I/O, so -m is currently is
>> disallowed.
> 
> I would be interested in putting in a new drive in the NAS and testing
> your patch to debug things, if that would help with multi-sector I/O
> getting fixed with libata.
..

It just needs someone to patch libata to sniff out "SET MULTIPLE" commands
from SG_IO, and perform drive revalidation afterwards.  Very similar to
how it currently sniffs "SET FEATURES XFERMODE" commands.

If libata did that, then "hdparm -m" would become safe to use with it.

Cheers
