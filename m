Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbYC1TCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbYC1TCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYC1TB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:01:58 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:28675 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753406AbYC1TB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:01:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jPyIL0AROSBAVQ5snl1OU7POZHovhdkWj9TfYxHYCPzDDII/2eqqen1qZhB9btlDcvZMmG7FwTSNFIjxuRKpne/KuaWnwhqBGgl4/Zqp41e5YLK11DINqUo/Yg2CHJELeIMYyd6uS1iKArehiMjXWwXEYMZ9bZD46bshx15CrJo=  ;
X-YMail-OSG: 60vct0AVM1nfQGPyXspt.x4o6khrDi712Mokid.3pfzI4WOQqgez6fVWYa0VeCEa2glJNYQWhw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>, venkatesh.pallipadi@intel.com
Subject: Re: 2.6.25 regression: powertop says 120K wakeups/sec
Date: Fri, 28 Mar 2008 12:01:53 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
References: <20080322202454.9D69DCC0EF@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20080322173500.7b8b6751.akpm@linux-foundation.org>
In-Reply-To: <20080322173500.7b8b6751.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281201.54380.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 March 2008, Andrew Morton wrote:
> On Sat, 22 Mar 2008 13:24:54 -0700 David Brownell <david-b@pacbell.net> wrote:
> 
> > I noticed this with 2.6.25-rc2 (if not before), and the problem
> > is still there with 2.6.25-rc6-git (as of this AM).

A 2.6.24 kernel I still had stashed away didn't act odd; the
problem joined us before 2.6.25-rc1 was tagged.

 
> > System is an Athlon64 single CPU laptop, and instead of reading a
> > few dozen wakeups per second, it says a many tens of thousands...
> > clearly wrong.  In previous kernels it gave more plausible counts;
> > unfortunately high because of various un-evolved desktop tools in
> > this Ubuntu system (Feisty).
> > 
> > Possibly more truthful, it says that the system never enters
> > C1 or C2, and spends all its time in C0.  Though if I look at
> > /sys/devices/system/cpu/cpu0/cpuidle/state[01]/usage, that
> > seems to tell a different story ... it's C0 that's never used.
> > In previous kernels it reported time in both C0 and C2.  ISTR
> > some patch to avoid C2, which would explain part of this.
> > 
> > Comments or fixes, anyone?
> 
> This is likely to be an acpi regression, isn't it?
> 
> A git-bisect would be nice, please.

The git-bisect says the 120K wakeups/second comes from a patch
which unfortunately can't be directly reverted, so I didn't
verify that reverting it resolves that problem.  I've not tried
to do anything with the other C0/C1/C2 stuff.


$ git bisect good
bc71bec91f9875ef825d12104acf3bf4ca215fa4 is first bad commit
commit bc71bec91f9875ef825d12104acf3bf4ca215fa4
Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
Date:   Thu Jan 31 17:35:04 2008 -0800

    ACPI: enable MWAIT for C1 idle
    
    Add MWAIT idle for C1 state instead of halt, on platforms that support
    C1 state with MWAIT.
    
    Renames cx->space_id to something more appropriate.
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

:040000 040000 88ebe48d024f7fb21237cd75dbc9c681c43252b1 8af87317facbd018b47e717ede6907d9a831f92c M	drivers
:040000 040000 ecd73d87c1b7b7004e06ffa3a2b3e7260c045543 934c38290353186cbaaaf27094d5c1712e548fcc M	include
$



