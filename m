Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbYFZRmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbYFZRmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYFZRmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:42:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:9401 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbYFZRmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:42:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,709,1204531200"; 
   d="scan'208";a="3098569"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Scatter-gather list constraints
Date: Thu, 26 Jun 2008 09:43:51 -0700
Message-ID: <C72DEB015BA7724783363DE1AF6B0F980510C8BB@orsmsx417.amr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.44L0.0806251023100.2578-100000@iolanthe.rowland.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Scatter-gather list constraints
Thread-Index: AcjWzz4jvqiBIAuAQJmGgOldLfYRrAAlGbBg
References: <C72DEB015BA7724783363DE1AF6B0F980510BAC2@orsmsx417.amr.corp.intel.com> <Pine.LNX.4.44L0.0806251023100.2578-100000@iolanthe.rowland.org>
From: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "David Vrabel" <david.vrabel@csr.com>,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "AntonioLin" <antonio.lin@alcormicro.com>, <linux-usb@vger.kernel.org>,
       <inaky@linux.intel.com>
X-OriginalArrivalTime: 26 Jun 2008 16:43:51.0384 (UTC) FILETIME=[D0485580:01C8D7AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>From: Alan Stern [mailto:stern@rowland.harvard.edu]
>
>> >> I suppose we could add a field to struct urb and add a flag
>> indicating
>> >> whether the controller driver supports S-G lists.
>> >
>> >This is what I was thinking.
>>
>> That would simplify a *LOT* of WUSB wire-adapter code which now is a
>> horrible kludge.
>
>In what way would it simplify the code?
>
>Note that usbcore already contains a scatter-gather library.
>(Unfortunately the library is limited in usefulness because it needs to
>run in process context.)
>
>Alan Stern

For WA, when we get a buffer to be sent from a URB, it has to be split
in chunks, each chunk has a header added. So we end up with a list of
chunks, most of them quite small. Each requires a single URB to send.
resources galore.

If we could queue all those, the overhead would be reduced to allocating
the headers (possibly in a continuous array) and the sg "descriptors"
to describe the whole thing.

However, the alignment stuff somebody mentioned in another email in this
thread might cause problems.

At the end it might not be all that doable (I might be missing some
subtle isssues), but it is well worth a look.

>Note that usbcore already contains a scatter-gather library.
>(Unfortunately the library is limited in usefulness because it needs to
>run in process context.)

And the overhead of one URB per sg "node" kills it's usability for
WAs.

