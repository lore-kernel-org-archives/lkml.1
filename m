Return-Path: <linux-kernel-owner+w=401wt.eu-S1760521AbYGQXBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760521AbYGQXBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757017AbYGQXBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:01:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:7562 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbYGQXBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:01:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,206,1215414000"; 
   d="scan'208";a="362555882"
From: "Stone, Joshua I" <joshua.i.stone@intel.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       "systemtap@sourceware.org" <systemtap@sourceware.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 17 Jul 2008 16:00:39 -0700
Subject: RE: [PATCH] systemtap: fix up on_each_cpu() for kernels 2.6.26+
Thread-Topic: [PATCH] systemtap: fix up on_each_cpu() for kernels 2.6.26+
Thread-Index: AcjoLW7uy1FgTr2RRkyN9EGUvgcaWAAMX0Bw
Message-ID: <60BA3EDE80604C4BAEE4AAF7FF714D185813FCF4@orsmsx504.amr.corp.intel.com>
References: <1216313476.5515.16.camel@localhost.localdomain>
In-Reply-To: <1216313476.5515.16.camel@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> In kernel 2.6.26, this patch
>
> commit 15c8b6c1aaaf1c4edd67e2f02e4d8e1bd1a51c0d
> Author: Jens Axboe <jens.axboe@oracle.com>
> Date:   Fri May 9 09:39:44 2008 +0200
>
>     on_each_cpu(): kill unused 'retry' parameter
>
> means that runtime/time.c is now using the wrong calling conventions.
> Fix this up and surround it by kernel versioning #ifdefs.

On a closer look, the referenced commit wasn't actually merged until
sometime between v2.6.26-git2 and -git3.  The released v2.6.26 still
has 'retry' in on_each_cpu(), so we'll either have to use an autoconf
test to detect the change, or wait and key the #ifdef on 2.6.27.

Josh
