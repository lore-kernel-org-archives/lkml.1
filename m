Return-Path: <linux-kernel-owner+w=401wt.eu-S1759767AbYDCBcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759767AbYDCBcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 21:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbYDCBcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 21:32:04 -0400
Received: from coffee.shu.ac.uk ([143.52.2.44]:53188 "EHLO coffee.shu.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757142AbYDCBcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 21:32:03 -0400
X-Greylist: delayed 1471 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2008 21:32:03 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: BUG: soft lockup detected on Phenom with Debian 2.6.24-4
Date: Thu, 3 Apr 2008 02:04:23 +0100
Message-ID: <F48CD7752D86EC4CAD59AE7CAFDAA60B011DE00E@foxglove.hallam.shu.ac.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: BUG: soft lockup detected on Phenom with Debian 2.6.24-4
Thread-Index: AciVGa5aIowfTtgwS06mpn5qaPDmGwAC2Jkx
References: <1205013615.15075.409.camel@localhost>	 <1205678588.15075.563.camel@localhost> <1206015619.15075.666.camel@localhost> <47E26A5D.40401@amd.com>
From: "Schmielau, Tim" <T.Schmielau@shu.ac.uk>
To: "Peter Oruba" <peter.oruba@amd.com>, "Laurent GUERBY" <laurent@guerby.net>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 03 Apr 2008 01:04:24.0156 (UTC) FILETIME=[A818E9C0:01C89526]
X-SHU-MailScanner-Information: Please contact the ISP for more information
X-SHU-MailScanner: Found to be clean
X-MailScanner-From: acests@exchange.shu.ac.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 3/20/2008 1:45 PM, Peter Oruba wrote:
 
> you may have triggered the L2 eviction bug (E298).
> 
> Please try
> 
> hexdump -s 0xc0010015 -n 8 -C /dev/cpu/0/msr
> 
> Output is little-endian, so the left-most byte must have bit 3 enabled meaning 
> TLB caching is disabled.

While this question was not directed at me, I indeed find that bit 3 of the
leftmost byte is set with 2.6.24:

  # hexdump -s 0xc0010015 -n 8 -C /dev/cpu/0/msr
  c0010015  18 00 00 01 00 00 00 00                           |........|
  c001001d
  # uname -a
  Linux quad 2.6.24.4-default #1 SMP Mon Mar 31 18:51:48 BST 2008 x86_64 x86_64 x86_64 GNU/Linux

while (as expected) it was zero running 2.6.23.17 patched with the erratum 298
workaround. Yet I saw the lockups with both kernels.

Thanks,
Tim
