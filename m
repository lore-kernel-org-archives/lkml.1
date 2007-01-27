Return-Path: <linux-kernel-owner+w=401wt.eu-S1751038AbXA0JUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038AbXA0JUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 04:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbXA0JUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 04:20:23 -0500
Received: from 1-1-8-31a.gmt.gbg.bostream.se ([82.182.75.118]:62531 "EHLO
	lin5.shipmail.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750958AbXA0JUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 04:20:21 -0500
Message-ID: <45BB1952.8000903@tungstengraphics.com>
Date: Sat, 27 Jan 2007 10:20:18 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.7.8) Gecko/20050511
X-Accept-Language: sv, en-us, en
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Support for i386 PATs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Does anybody have a strong opinion against adding support for
i386 Page Attribute Tables?

The main benefit would be that one can have write-combining memory
regions without setting up MTRRs. This will come in handy for a
device we're working with where the device driver needs to allocate the
display memory directly from system memory, and it may be difficult to fit
the mtrr alignment constraints.

Outline:
The PAT may be set up at boot time with fixed backwards-compatible
memory types for the different PAT entries + defines like the following:

#define _PAGE_PAT_WB   xxx
#define _PAGE_PAT_WT   xxx
#define _PAGE_PAT_UC0 xxx
#define _PAGE_PAT_UC1 xxx
#define _PAGE_PAT_WC   xxx

which can be used in parallel with the old _PAGE_PWT and _PAGE_PCD bits.

The idea is that new memory types, WC for example, will use the pat entries
7 downto 4, whereas 0-3 are left to boot setting to maintain backwards 
compatibility.

Issues:
1) The _PAGE_BIT_PAT will be the same as _PAGE_PSE, and _PAGE_PROTNONE.
As I understand it, _PAGE_PROTNONE is not used when the page is present, 
so this might not be an issue.
What about _PAGE_PSE?

2) The PATs need to be setup for each processor just after system boot.
Where is the best place to do this?

/Thomas Hellström


