Return-Path: <linux-kernel-owner+w=401wt.eu-S933503AbXILXrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503AbXILXrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 19:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999AbXILXqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 19:46:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:30165 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbXILXqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 19:46:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,246,1186383600"; 
   d="scan'208";a="277761611"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Update: Ext3 vs NTFS performance
Date: Wed, 12 Sep 2007 16:47:03 -0700
Message-ID: <B326D0531AF1BA48B4C1E9EBA239A050043470D1@scsmsx412.amr.corp.intel.com>
In-Reply-To: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Update: Ext3 vs NTFS performance
Thread-Index: AceMMVmfbjj7uGfMSkii7VTHJN/BExpZD6lQ
References: <B326D0531AF1BA48B4C1E9EBA239A050033DB3C1@scsmsx412.amr.corp.intel.com>
From: "Cabot, Mason B" <mason.b.cabot@intel.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Cabot, Mason B" <mason.b.cabot@intel.com>
X-OriginalArrivalTime: 12 Sep 2007 23:46:52.0548 (UTC) FILETIME=[31AA9C40:01C7F597]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Ext3 vs NTFS performance
> 
> Hello all,
> 
> I've been testing the NAS performance of ext3/Openfiler 2.2 against
> NTFS/WinXP and have found that NTFS significantly outperforms ext3 for
> video workloads. The Windows CIFS client will attempt a poor-man's
> pre-allocation of the file on the server by sending 1-byte writes at
> 128K-byte strides, breaking block allocation on ext3 and leading to
> fragmentation and poor performance. This will happen for many
> applications (including iTunes) as the CIFS client issues these
> pre-allocates under the application layer.
> 
> I've posted a brief paper on Intel's OSS website
> (http://softwarecommunity.intel.com/articles/eng/1259.htm). 
> Please give
> it a read and let me know what you think. In particular, I'd like to
> arrive at the right place to fix this problem: is it in the 
> filesystem,
> VFS, or Samba?
> 
> thanks,
> Mason 
> 
> (please CC responses to mason dot b dot cabot at intel dot com)
> 

Folks:

thanks for the comments from the initial posting of this note. We've
looked further into the problem and found that Samba 3.0.20 or greater
fills the performance gap for ext3: the "strict allocate" flag now zero
fills the file, forcing allocation in the underlying filesystem and
avoiding fragmentation.

An update to the original whitepaper will be posted soon to the same
location on Intel's OSS website.

thanks,
Mason

(please CC responses to mason dot b dot cabot at intel dot com)
