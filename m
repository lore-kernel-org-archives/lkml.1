Return-Path: <linux-kernel-owner+w=401wt.eu-S1751376AbXLZS2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbXLZS2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 13:28:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbXLZS15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 13:27:57 -0500
Received: from iriserv.iradimed.com ([72.242.190.170]:53985 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751159AbXLZS15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 13:27:57 -0500
Message-ID: <47729D25.9090904@cfl.rr.com>
Date: Wed, 26 Dec 2007 13:27:49 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Marc Haber <mh+linux-kernel@zugschlus.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <47584E35.7030409@tmr.com> <20071208220345.GE20441@stusta.de> <475EAFF9.9020405@tmr.com> <20071220222738.GA24489@torres.zugschlus.de>
In-Reply-To: <20071220222738.GA24489@torres.zugschlus.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Dec 2007 18:28:14.0771 (UTC) FILETIME=[13F51830:01C847ED]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1023-15630.000
X-TM-AS-Result: No--11.157600-5.000000-4
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Haber wrote:
> On Tue, Dec 11, 2007 at 10:42:49AM -0500, Bill Davidsen wrote:
>> The original point was that urandom draws entropy from random, and that 
>> it is an an inobvious and unintentional drain on the entropy pool. At 
>> least that's how I read it.
> 
> And you are reading it correct. At least one of the major TLS
> libraries does it this way, putting unnecessary stress on the kernel
> entropy pool. While I now consider this a bug in the library, there
> surely are gazillions of similiarily flawed applications out there in
> the wild.

It seems to me that reading from (u)random disturbs the entropy pool, so 
the more consumers reading from the pool in unpredictable ways, the 
better.  As it is currently implemented, it lowers the entropy estimate, 
but the pool will have MORE entropy if several applications keep reading 
/dev/random periodically when they need random bytes instead of just 
reading it once to seed their own prng.  IMHO, it is the entropy 
estimate that is broken, not the TLS library.


