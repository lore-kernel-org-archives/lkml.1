Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbZDVUrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbZDVUrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZDVUrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:47:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:28790 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214AbZDVUrF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:47:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,232,1239001200"; 
   d="scan'208";a="684021112"
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>, "Wang, Shane" <shane.wang@intel.com>
Date: Wed, 22 Apr 2009 13:47:02 -0700
Subject: RE: [RFC v2][PATCH 1/1] intel_txt: Intel(R) TXT and tboot kernel
 support
Thread-Topic: [RFC v2][PATCH 1/1] intel_txt: Intel(R) TXT and tboot kernel
 support
Thread-Index: AcnDihciW+6teuK6TFStG3ZU1OqrfgAARdOQ
Message-ID: <4F65016F6CB04E49BFFA15D4F7B798D998812BA7@orsmsx506.amr.corp.intel.com>
References: <49D1A6AB.5090808@intel.com> <87d4baqnxy.fsf@basil.nowhere.org>
 <49EF7E85.7040104@goop.org> <20090422204028.GC13896@one.firstfloor.org>
In-Reply-To: <20090422204028.GC13896@one.firstfloor.org>
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

> From: Andi Kleen [mailto:andi@firstfloor.org]
> Sent: Wednesday, April 22, 2009 1:40 PM
>
> On Wed, Apr 22, 2009 at 01:31:01PM -0700, Jeremy Fitzhardinge wrote:
> > Andi Kleen wrote:
> > >This means it explodes with paravirt, right? Do you have a check early
> > >for that?
> > >
> >
> > The tboot stuff should only be run on bare hardware; if there's
> > virtualization under the kernel, then TXT should be happening at that level.
>
> Yes I know, but still this should be enforced.

This code will only be executed if the tboot_shared page is found, which should not be the case if the kernel is running paravirtualized.  But I'm planning to change it to just write_cr3() to be more consistent with other cases where we don't try to specifically exclude paravirt hooks.

Joe
