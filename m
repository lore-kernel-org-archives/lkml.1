Return-Path: <linux-kernel-owner+w=401wt.eu-S965059AbXCVTKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965059AbXCVTKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965238AbXCVTKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:10:10 -0400
Received: from 68-191-203-42.static.stls.mo.charter.com ([68.191.203.42]:10474
	"EHLO service.eng.exegy.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965059AbXCVTKJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:10:09 -0400
X-Ninja-PIM: Scanned by Ninja
X-Ninja-AttachmentFiltering: (no action)
thread-index: AcdstYJR9Nn3qPLNQ5W7+oKl0M2Klg==
Message-ID: <4602D433.3070406@exegy.com>
Date: Thu, 22 Mar 2007 14:08:35 -0500
From: "Mr. Berkley Shands" <bshands@exegy.com>
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.2826
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: linux-xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Quick fix for LSI8888ELP overruns in 2.6.20 and 2.6.21-rc4
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
X-OriginalArrivalTime: 22 Mar 2007 19:08:43.0275 (UTC) FILETIME=[823525B0:01C76CB5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My local kernel guru recognized this problem as a duplicate of the
LSI8408E bus lockup problem. The controller gets flooded with work,
and just climbs under a rock to hide. In the 8408E case, it
froze the PCI-e bus :-)

#!/bin/csh
#
# set the max request queue down from 128. any more than 32
# quickly slows down from 810MB/Sec to 11MB/Sec.
#
setenv X 32
#
foreach i ( /sys/block/sd{g,h,i,j,k,l,m,n}/queue/nr_requests)
   echo $X > $i
   end

Lots of time was spent in the congestion queue, like 99% of the time.

Berkley
This e-mail and any documents accompanying it may contain legally privileged and/or confidential information belonging to Exegy, Inc. Such information may be protected from disclosure by law. The information is intended for use by only the addressee. If you are not the intended recipient, you are hereby notified that any disclosure or use of the information is strictly prohibited. If you have received this e-mail in error, please immediately contact the sender by e-mail or phone regarding instructions for return or destruction and do not use or disclose the content to others.
