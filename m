Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbYIZWXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbYIZWXv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 18:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYIZWXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 18:23:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:21482 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbYIZWXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 18:23:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,316,1220252400"; 
   d="scan'208";a="444146397"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: e1000e NVM corruption issue status
Date: Fri, 26 Sep 2008 15:23:39 -0700
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F5206446B4E@orsmsx418.amr.corp.intel.com>
In-Reply-To: <m34p42mumu.fsf@maximus.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: e1000e NVM corruption issue status
Thread-Index: AckgI9sQLRZvmoc8SL6ExLSkhYvF1QAALGyg
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com><48DCCC5F.8040609@linux.intel.com><200809261052.38966.jbarnes@virtuousgeek.org><200809261123.52198.jbarnes@virtuousgeek.org><48DD2F98.8070509@tpi.com> <m34p42mumu.fsf@maximus.localdomain>
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>, "Tim Gardner" <timg@tpi.com>
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Jiri Kosina" <jkosina@suse.cz>, "LKML" <linux-kernel@vger.kernel.org>,
       <agospoda@redhat.com>, "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, <kkiel@suse.de>,
       <tglx@linutronix.de>, <chris.jones@canonical.com>,
       <arjan@linux.jf.intel.com>
X-OriginalArrivalTime: 26 Sep 2008 22:23:40.0799 (UTC) FILETIME=[875328F0:01C92026]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> But... do you really have a flash chip there? I think it's more about
> EEPROM (a serial usually 8-pin small chip, keeping the MAC address and
> hardware configuration). Flash chips are used for diskless booting
> (though corrupting them can make the machine unbootable of course).
> 
> Sure, writing to a parallel flash chip is easy, much easier than to
> serial EEPROM.

ICH 8/9/10 machines with Intel gigabit part integrated (82566/82567)
share the system Flash space with all the other system devices, BIOS,
etc.  The gigabit region is the currently only "unprotected" region I
know of.  It is never directly memory mapped, but the registers that
program to it are memory mapped from our BAR1, like Tim said, possibly
only requiring an errant write of a few bits of ones, to erase it (I've
been trying to confirm that)

