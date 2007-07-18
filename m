Return-Path: <linux-kernel-owner+w=401wt.eu-S1762085AbXGRJc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762085AbXGRJc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbXGRJcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:32:45 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:51778 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366AbXGRJcn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:32:43 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "lkml List" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] faking and fixing the NUMA SLIT
Date: Wed, 18 Jul 2007 11:30:01 +0200
User-Agent: KMail/1.9.7
cc: gregkh@suse.de, "Andreas Kleen" <ak@suse.de>, lenb@kernel.org,
       "Christoph Lameter" <clameter@sgi.com>
MIME-Version: 1.0
Message-ID: <200707181130.01861.joachim.deguara@amd.com>
X-OriginalArrivalTime: 18 Jul 2007 09:32:24.0968 (UTC)
 FILETIME=[8CACB880:01C7C91E]
X-WSS-ID: 6A8301A50X81901213-01-01
Content-Disposition: inline
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The problem with NUMA distances in the SLIT is that they are often wrong, oh 
wait they aren't there at all because the BIOS didn't create a SLIT since 
Windows does not use it.  If Linux does not find a slit it just says the 
distance to local=10 and remote=20 according to ACPI spec.  The problem is 
when we have a 4P system (or larger), there is generally one node where we 
have two hops and its distance should be >20.

Following are patches to first fake the SLIT in the ACPI code and then add 
ability to write the distances from sysfs.

-Joachim


