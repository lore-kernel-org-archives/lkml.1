Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbYFPBtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbYFPBtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 21:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYFPBtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 21:49:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:14838 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbYFPBtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 21:49:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,649,1204531200"; 
   d="scan'208";a="294736842"
Subject: Re: [PATCH -mm 1/2] kexec jump -v11: kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20080613180059.GA4906@redhat.com>
References: <1213082104.22608.29.camel@caritas-dev.intel.com>
	 <20080612192015.GH9654@redhat.com>
	 <1213319040.20431.8.camel@caritas-dev.intel.com>
	 <20080613180059.GA4906@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 16 Jun 2008 09:52:21 +0800
Message-Id: <1213581141.7179.6.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 16 Jun 2008 01:49:26.0423 (UTC) FILETIME=[3557A270:01C8CF53]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-13 at 14:00 -0400, Vivek Goyal wrote:
[...]
> Ok, I found that in my config CONFIG_HIBERNATION was not enabled. After
> enabling CONFIG_HIBERNATION, both suspend to disk and kjump started
> working.
> 
> Does that mean there is some dependency on code under CONFIG_HIBERNATION.
> If yes, I think this dependency should be resolved during compile time.
> May be addtional config option (CONFIG_KEXEC_JUMP), which also selects
> the CONFIG_HIBERNATION automatically etc...

Yes. kexec jump need to put devices into quiescent state and save
devices state into memory, which is implemented by calling hibernation
function: device_suspend(PMSG_FREEZE), whose implementation depends on 
CONFIG_HIBERNATION.

So, I will add CONFIG_KEXEC_JUMP and select CONFIG_HIBERNATION
automatically.

Best Regards,
Huang Ying

