Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbXHWK52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbXHWK52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 06:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbXHWK5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 06:57:21 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:7697 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbXHWK5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 06:57:21 -0400
Subject: Re: [PATCH] s390 appldata_base: Remove module_exit function and
	modular stuff
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Satyam Sharma <satyam@infradead.org>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0708230746450.2049@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0708230706570.2049@enigma.security.iitk.ac.in >
	 <alpine.LFD.0.999.0708230746450.2049@enigma.security.iitk.ac.in>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 23 Aug 2007 13:01:06 +0200
Message-Id: <1187866866.6599.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-23 at 07:51 +0530, Satyam Sharma wrote: 
> > BTW the __exit module_exit function appldata_exit() of this driver
> > fails to unregister_hotcpu_notifier() the notifier_block that was
> > registered by appldata_init() during module startup. This will lead
> > to oops if hotplug notification comes after module has been unloaded.
> > Let's fix this by unregistering the notifier appropriately (before
> > appldata_offline_cpu()'ing the CPUs).
> 
> Heh, no wonder we never saw this oops before. This code can never be
> built as a module! :-) But why does it define and implement an __exit
> marked module_exit(appldata_exit) function in that case ?!

I has been a module once for debugging purposes That the module_exit
function still exists is "historical". We can remove it since it is dead
code.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


