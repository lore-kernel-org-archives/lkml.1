Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbYFTLQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbYFTLQG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 07:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYFTLP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 07:15:56 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:58040 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751770AbYFTLPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 07:15:55 -0400
Date: Fri, 20 Jun 2008 12:15:53 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
Subject: MMC test driver - help with output
Message-ID: <20080620111553.GC21835@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm testing the s3c24xx sd/mmc driver and can't find any
documentation for each of the tests the mmc_test driver is
doing.

The following is output from a recent linux-next+driver:

[root@ ~]# echo > /sys/class/mmc_host/mmc0/mmc0\:0001/test
mmc0: Starting tests of card mmc0:0001...
mmc0: Test case 1. Basic write (no data verification)...
mmc0: Result: OK
mmc0: Test case 2. Basic read (no data verification)...
mmc0: Result: OK
mmc0: Test case 3. Basic write (with data verification)...
mmc0: Result: OK
mmc0: Test case 4. Basic read (with data verification)...
mmc0: Result: OK
mmc0: Test case 5. Multi-block write...
mmc0: Warning: Host did not wait for busy state to end.
mmc0: Result: OK
mmc0: Test case 6. Multi-block read...
mmc0: Result: OK
mmc0: Test case 7. Power of two block writes...
mmc0: Result: UNSUPPORTED (by card)
mmc0: Test case 8. Power of two block reads...
s3c2440-sdi s3c2440-sdi: unfinished read - pio_count:[0] pio_words:[0]
mmc0: Result: UNSUPPORTED (by host)

=> probably the wrong error being returned, but what would be
the general problem with this causing a finish before the driver
has decided that there should have been data to read?

mmc0: Test case 9. Weird sized block writes...
mmc0: Result: UNSUPPORTED (by card)
mmc0: Test case 10. Weird sized block reads...
s3c2440-sdi s3c2440-sdi: unfinished read - pio_count:[0] pio_words:[0]
mmc0: Result: UNSUPPORTED (by host)
mmc0: Test case 11. Badly aligned write...
mmc0: Result: OK
mmc0: Test case 12. Badly aligned read...
mmc0: Result: OK
mmc0: Test case 13. Badly aligned multi-block write...
mmc0: Warning: Host did not wait for busy state to end.
mmc0: Warning: Host did not wait for busy state to end.
mmc0: Warning: Host did not wait for busy state to end.
mmc0: Result: OK
mmc0: Test case 14. Badly aligned multi-block read...
mmc0: Result: OK
mmc0: Test case 15. Correct xfer_size at write (start failure)...
s3c2440-sdi s3c2440-sdi: bad data crc (incoming)

=> is this sort of error what was exepected?

mmc0: Result: ERROR (-84)
mmc0: Test case 16. Correct xfer_size at read (start failure)...
s3c2440-sdi s3c2440-sdi: data timeout
mmc0: Result: OK

=> is this the expected response?

mmc0: Test case 17. Correct xfer_size at write (midway failure)...
s3c2440-sdi s3c2440-sdi: bad data crc (incoming)
mmc0: Result: ERROR (-84)
mmc0: Test case 18. Correct xfer_size at read (midway failure)...
s3c2440-sdi s3c2440-sdi: data timeout
mmc0: Result: OK
mmc0: Tests completed.
[root@ ~]# 

Also, any indications of how the "busy state" warnings could be
debugged?

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
