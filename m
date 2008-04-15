Return-Path: <linux-kernel-owner+w=401wt.eu-S1759690AbYDOOxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759690AbYDOOxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 10:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761376AbYDOOxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 10:53:36 -0400
Received: from ag-out-0708.google.com ([72.14.246.244]:27948 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761162AbYDOOxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 10:53:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=GVElfbxalDonzzL5IrjmDpAtfRUEQJ9cpvZaVhXnt64Bg61yAEcXnrg4Fcx+AVTqxwVwPbWdfmvjyLfCKL9iXS3Qb+w5Bx4N56OUUg3NvtcwhrSmdIERr0uyf9iTifj0a73+9E6dNJv2jI0iZR6GWYPYBeOJHdZtBSZCEZILbrY=
Message-ID: <7c86c4470804150753o51668587l24dfa145266d73ac@mail.gmail.com>
Date: Tue, 15 Apr 2008 16:53:33 +0200
From: "stephane eranian" <eranian@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: perfmon and Markus' DS/BTS/PEBS interface
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


Over the last few weeks, I have been working with Markus Metzger from
Intel to add support
for Precise Event-Based Sampling (PEBS) to his ds.c/ds.h interface. I
thought this could help
simplify some of the perfmon code.

The current ds.h/ds.c code in 2.6.25-rc8 does not yet have PEBS
support. It only has Branch
Trace Stack (BTS) support. Markus developed the PEBS extension. It is
fairly simple and
small. I strongly believe it should be included in mainline very soon.
To verify that it would
work correctly with perfmon, I did the experiment last week.

I just wanted to report to this list that I have now successfully
connected perfmon to ds.h. It allows
some more simplifications in perfmon. In particular, it does not have
to manage the DS_AREA
MSR on context switch anymore. Similarly, the layout differences
between Pentium 4 and
Intel Core processors for the DS_AREA are now hidden, meaning more
code can be factorized.
At the user level, it also simplifies the interface as we do not have
to expose as much information
as we used to (e.g., DS_AREA is not exposed anymore).

Overall I am satisfied with this patch and I recommend you accept the
extended ds.h/ds.c interface.

Thanks.
