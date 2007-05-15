Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbXEOXXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbXEOXXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 19:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbXEOXXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 19:23:33 -0400
Received: from 203-97-71-235.dsl.clear.net.nz ([203.97.71.235]:46494 "EHLO
	gazelle.ad.endace.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755845AbXEOXXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 19:23:33 -0400
X-Greylist: delayed 850 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2007 19:23:32 EDT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: Software raid0 will crash the file-system, when each disk is 5TB
Date: Wed, 16 May 2007 11:09:20 +1200
Message-ID: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Software raid0 will crash the file-system, when each disk is 5TB
Thread-Index: AceXRhGsbzMG9dV9Qk2NbqlR20dznw==
From: "Jeff Zheng" <Jeff.Zheng@endace.com>
To: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone:

	We are experiencing problems with software raid0, with very
large disk arrays.
We are using two 3ware disk array controllers, each of them is connected
8 750GB harddrives. And we build a software raid0 on top of that. The
total capacity is 5.5TB+5.5TB=11TB

We use jfs as the file-system, we have a test application that write
data continuously to the disks. After writing 52 10GB files, jfs
crashed. And we are not able to recover it, fsck doesn't recognise it
anymore.
We then tried xfs, same application, lasted a little longer, but gives
kernel crash later.

We then reconfigured the hardware array, this time we configured two
disk array from each controller, than we have 4 disk arrays, each of
them have 4 750GB harddrives. Than build a new software raid0 on top of
that. Total capacity is still the same, but 2.75T+2.75T+2.75T+2.75T=11T.

This time we managed to fill the whole 11T data without problem, we are
still doing validation on all 11TB of data written to the disks.

It happened on 2.6.20 and 2.6.13.

So I think the problem is in the way on software raid handling very
large disk, maybe a integer overflow or something. I've searched on the
web, only find another guy complaining the same thing on the xfs mailing
list.

Anybody have a clue?


Jeff
