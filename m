Return-Path: <linux-kernel-owner+w=401wt.eu-S1161556AbXEDTwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161556AbXEDTwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161922AbXEDTwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:52:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:25480 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161556AbXEDTwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:52:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,494,1170662400"; 
   d="scan'208";a="239437367"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Ext3 vs NTFS performance
Date: Fri, 4 May 2007 12:52:30 -0700
Message-ID: <B326D0531AF1BA48B4C1E9EBA239A0500343FD11@scsmsx412.amr.corp.intel.com>
In-Reply-To: <463B81D4.50401@cfl.rr.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Ext3 vs NTFS performance
Thread-Index: AceOfdu2BOeZb5guTMSFlac7bLRBHQABykaQ
From: "Cabot, Mason B" <mason.b.cabot@intel.com>
To: "Phillip Susi" <psusi@cfl.rr.com>
CC: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 04 May 2007 19:52:19.0762 (UTC) FILETIME=[B984A120:01C78E85]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Cabot, Mason B wrote:
> > I've been testing the NAS performance of ext3/Openfiler 2.2 against
> > NTFS/WinXP and have found that NTFS significantly 
> outperforms ext3 for
> > video workloads. The Windows CIFS client will attempt a poor-man's
> > pre-allocation of the file on the server by sending 1-byte writes at
> > 128K-byte strides, breaking block allocation on ext3 and leading to
> > fragmentation and poor performance. This will happen for many
> > applications (including iTunes) as the CIFS client issues these
> > pre-allocates under the application layer.
> 
> This is rather hard to believe so I think some more information is in 
> order.  Specifically, how do you know that it is the windows 
> kernel that 
> is issuing these writes and not the application?  Under what 
> application 
> access patterns does it do this?
> 
> This is just rather hard to believe seeing as how, iirc, the CIFS 
> protocol has commands to extend the file size properly rather 
> than with 
> this hack, and unless it is asked to by the application, the 
> cifs client 
> should not be trying to extend files.
>

Philip:

the best response I can offer is that we have traced the application's
file system accesses and seen no such one-byte writes occuring at that
level. They are generated somewhere below the application. Additionally,
while we have observed iTunes on Windows issuing these one-byte writes,
ethereal traces for iTunes on Mac OSX show no such behavior. Because of
these observations I think it is reasonable to conclude that the Windows
CIFS client is generating the one-byte writes.

thanks,
Mason
 
