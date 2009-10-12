Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZJLDvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZJLDvH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 23:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbZJLDvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 23:51:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:8265 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbZJLDvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 23:51:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,544,1249282800"; 
   d="scan'208";a="735385121"
Subject: Re: [Bug #14379] ACPI Warning for _SB_.BAT0._BIF: Converted Buffer
 to 	expected String
From: Lin Ming <ming.m.lin@intel.com>
To: Justin Mattock <justinmattock@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <dd18b0c30910112014m4bfdc238j542864bb9f1e8161@mail.gmail.com>
References: <zJ_pXHNwoHC.A.akB.Aal0KB@chimera>
	 <r-4Wjt4coy.A.ZrC.Ual0KB@chimera>
	 <dd18b0c30910112014m4bfdc238j542864bb9f1e8161@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 12 Oct 2009 11:35:56 +0800
Message-Id: <1255318556.11664.11.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 11:14 +0800, Justin Mattock wrote:
> On Sun, Oct 11, 2009 at 3:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.31.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14379
> > Subject         : ACPI Warning for _SB_.BAT0._BIF: Converted Buffer to expected String
> > Submitter       : Justin Mattock <justinmattock@gmail.com>
> > Date            : 2009-10-08 21:46 (4 days old)
> > References      : http://marc.info/?l=linux-kernel&m=125504031328941&w=4
> >
> >
> >
> 
> pulled rc4 today and the warning is still present.
> here is the results of git bisect:

Patch at http://bugzilla.kernel.org/show_bug.cgi?id=14379#c1 fixes the
warning.

Actually, the _BIF warning was fixed at commit
e899b6485c332aa2d7510739507ab5e5d7b28e59.
See http://bugzilla.kernel.org/show_bug.cgi?id=11822#c14 

I made a mistake at the cleanup of predefined method table so the
warning shows up again.

Lin Ming

> 
> d9adc2e031bd22d5d9607a53a8d3b30e0b675f39 is the first bad commit
> commit d9adc2e031bd22d5d9607a53a8d3b30e0b675f39
> Author: Lin Ming <ming.m.lin@intel.com>
> Date:   Mon Jul 27 11:31:10 2009 +0800
> 
>     ACPICA: reformat predefined method table, no functional change
> 
>     Reformatted the methods that return package objects.
> 
>     Signed-off-by: Lin Ming <ming.m.lin@intel.com>
>     Signed-off-by: Len Brown <len.brown@intel.com>
> 
> :040000 040000 17c30a6e75ce2fafc677b32bdcf3fbecae8458ab
> f43e38a2a4034bcc73ef14943e61187f11b08731 M      drivers
> 
> I will go and attach the git log to the bug report.
> 

