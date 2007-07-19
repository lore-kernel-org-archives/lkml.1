Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbXGSEKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbXGSEKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 00:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbXGSEKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 00:10:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:40148 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbXGSEKF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 00:10:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,553,1175497200"; 
   d="scan'208";a="268009481"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: which signal is sent to freeze process?
Date: Wed, 18 Jul 2007 21:09:56 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD6285508CB@scsmsx412.amr.corp.intel.com>
In-Reply-To: <200707191218.32730.nigel@nigel.suspend2.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: which signal is sent to freeze process?
thread-index: AcfJqx3jv5AjWBzCS+KUwHCZUtMJLwAD0CMQ
References: <A3258B497F1C1441AD36A2E8B45FD6285507A5@scsmsx412.amr.corp.intel.com> <200707191218.32730.nigel@nigel.suspend2.net>
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: "Nigel Cunningham" <nigel@nigel.suspend2.net>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Jul 2007 04:09:57.0982 (UTC) FILETIME=[AB62AFE0:01C7C9BA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can you point me to code where kernel captures process in signal
handling and code which runs after suspend to ram is finished?

-----Original Message-----
From: Nigel Cunningham [mailto:nigel@nigel.suspend2.net] 
Sent: Wednesday, July 18, 2007 7:19 PM
To: Agarwal, Lomesh
Cc: linux-kernel@vger.kernel.org
Subject: Re: which signal is sent to freeze process?

Hi.

On Thursday 19 July 2007 09:42:02 Agarwal, Lomesh wrote:
> My understanding is that Linux kernel sends a signal to freeze
processes
> during suspend2ram operation. Which signal is used to achieve this?
> The problem I am facing is that some of the system calls are failing
> with EINTR errno during suspend operation and I want to install a
signal
> handler for freeze signal with SA_RESTART flag. That should make the
> kernel to retry the system calls. Right?

No signal is sent. We tell affected processes that they have a signal
pending, 
and capture them in the signal handling code while the suspend to ram is

occuring. After the suspend to ram is finished, we recalculate whether
they 
have a signal pending, and let them continue.

Not being a guru on signal handling itself, I won't try to answer the
question 
itself :\.

Regards,

Nigel
