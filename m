Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbYI3Prq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbYI3Prq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbYI3Prh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:47:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:7863 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbYI3Prh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:47:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,338,1220252400"; 
   d="scan'208";a="53215892"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Jiri Kosina <jkosina@suse.cz>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-netdev@vger.kernel.org" <linux-netdev@vger.kernel.org>,
       "kkeil@suse.de" <kkeil@suse.de>,
       "agospoda@redhat.com" <agospoda@redhat.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Graham, David" <david.graham@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "chris.jones@canonical.com" <chris.jones@canonical.com>,
       "tim.gardner@intel.com" <tim.gardner@intel.com>,
       "airlied@gmail.com" <airlied@gmail.com>
Date: Tue, 30 Sep 2008 08:47:24 -0700
Subject: RE: [RFC PATCH 11/12] e1000e: write protect ICHx NVM to prevent
 malicious write/erase
Thread-Topic: [RFC PATCH 11/12] e1000e: write protect ICHx NVM to prevent
 malicious write/erase
Thread-Index: Acki+c+fB0KaMTeESQeA+ggQ2PK2uQAGa10A
Message-ID: <B27EBC40D200ED48A3F4CC2EBEABAE0B157C500E@orsmsx501.amr.corp.intel.com>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
 <20080930032013.22950.70966.stgit@jbrandeb-bw.jf.intel.com>
 <Pine.LNX.4.64.0809301439021.2307@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0809301439021.2307@twin.jikos.cz>
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

Yeah, we can do that.  I need to amend the patch a bit to prevent the protected range lock from being lifted unintentionally and will add some debug statements if/when any write/erase cycles fail.

-----Original Message-----
From: Jiri Kosina [mailto:jkosina@suse.cz]
Sent: Tuesday, September 30, 2008 5:41 AM
To: Brandeburg, Jesse
Cc: linux-kernel@vger.kernel.org; linux-netdev@vger.kernel.org; kkeil@suse.de; agospoda@redhat.com; arjan@linux.intel.com; Graham, David; Allan, Bruce W; Ronciak, John; Thomas Gleixner; chris.jones@canonical.com; tim.gardner@intel.com; airlied@gmail.com; Allan, Bruce W
Subject: Re: [RFC PATCH 11/12] e1000e: write protect ICHx NVM to prevent malicious write/erase

On Mon, 29 Sep 2008, Jesse Brandeburg wrote:

> Set the hardware to ignore all write/erase cycles to the GbE region in
> the ICHx NVM.  This feature can be disabled by the WriteProtectNVM module
> parameter (enabled by default) though that is not recommended.
>
> Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

I guess there is no chance to have kernel somehow notified when
write/erase cycle is unsuccessfully tried, is it? This way, it would also
make chasing the root cause easier.

Thanks,

--
Jiri Kosina
SUSE Labs

