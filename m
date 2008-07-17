Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbYGQRms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbYGQRms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760845AbYGQRmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:42:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:27152 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759177AbYGQRmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:42:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,204,1215414000"; 
   d="scan'208";a="21650160"
From: "Stone, Joshua I" <joshua.i.stone@intel.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       "systemtap@sourceware.org" <systemtap@sourceware.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 17 Jul 2008 10:42:33 -0700
Subject: RE: [PATCH] systemtap: fix up on_each_cpu() for kernels 2.6.26+
Thread-Topic: [PATCH] systemtap: fix up on_each_cpu() for kernels 2.6.26+
Thread-Index: AcjoLbR+Fg5JZnWqRPuYo3suwnzlywABAwxQ
Message-ID: <60BA3EDE80604C4BAEE4AAF7FF714D185813F8C3@orsmsx504.amr.corp.intel.com>
References: <1216313476.5515.16.camel@localhost.localdomain>
 <1216313591.5515.19.camel@localhost.localdomain>
In-Reply-To: <1216313591.5515.19.camel@localhost.localdomain>
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
> On Thu, 2008-07-17 at 11:51 -0500, James Bottomley wrote:
>> In kernel 2.6.26, this patch
>>
>> commit 15c8b6c1aaaf1c4edd67e2f02e4d8e1bd1a51c0d
>> Author: Jens Axboe <jens.axboe@oracle.com>
>> Date:   Fri May 9 09:39:44 2008 +0200
>>
>>     on_each_cpu(): kill unused 'retry' parameter
>>
>> means that runtime/time.c is now using the wrong calling conventions.
>> Fix this up and surround it by kernel versioning #ifdefs.
>
> By the way, this is a classic illustration of the fragility problem
> in holding the systemtap runtime outside of the kernel.  If it had
> been in-kernel, all this would be fixed up and running and no-one
> would even have noticed.

Believe it or not, we really do understand this sentiment.

The whole runtime/time.c in particular is a fairly ugly way for us to
get a call-anywhere gettimeofday.  I would love to see an in-kernel
replacement for this, but I don't have the expertise to know how to
approach it myself.

Josh
