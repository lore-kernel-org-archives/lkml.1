Return-Path: <linux-kernel-owner+w=401wt.eu-S1756551AbXJBSvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551AbXJBSvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 14:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbXJBSu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 14:50:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:56317 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753811AbXJBSuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 14:50:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,221,1188802800"; 
   d="scan'208";a="291298251"
From: "Sean Hefty" <sean.hefty@intel.com>
To: "'Roland Dreier'" <rdreier@cisco.com>
Cc: <general@lists.openfabrics.org>, <linux-kernel@vger.kernel.org>,
       <netdev@vger.kernel.org>
References: <adahclymos8.fsf@cisco.com><000401c7f632$c993e8e0$65cc180a@amr.corp.intel.com><adatzpyl1mm.fsf@cisco.com><000001c7f6f7$074584e0$9c98070a@amr.corp.intel.com> <adaprzxgyoi.fsf@cisco.com>
Subject: RE: [ofa-general] InfiniBand/RDMA merge plans for 2.6.24
Date: Tue, 2 Oct 2007 11:50:04 -0700
Message-ID: <000601c80525$0b661f30$ff0da8c0@amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <adaprzxgyoi.fsf@cisco.com>
thread-index: AcgFIdWJnWlJwPuMQgex3a3JHwVGxQAAFORQ
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-OriginalArrivalTime: 02 Oct 2007 18:50:04.0586 (UTC) FILETIME=[0B8E40A0:01C80525]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>Umm... this is a difficult situation for me to merge the changes then.
>We're changing the CM retry behavior blind here.  How do we know that
>the MRA changes don't make the scalability issue worse?

What's currently upstream doesn't work for Intel MPI on our larger clusters.
The connection requests time out on the active side before the passive side can
respond.

The OFED release works because it provides a kernel patch to make the timeout a
module parameter.  I'm trying to avoid adding a module parameter, and the MRA is
designed for this situation.

I tested this by simulating a slow passive side responder, and it worked as
expected for those tests.  Using an MRA does add another MAD to the CM exchange,
which is why it is sent only after seeing a duplicate request.  Alternatively,
we can take the OFED module parameter patch.

- Sean
