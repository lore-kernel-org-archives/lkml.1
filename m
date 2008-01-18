Return-Path: <linux-kernel-owner+w=401wt.eu-S1764325AbYARWBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764325AbYARWBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759132AbYARWBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:01:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35291 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496AbYARWBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:01:07 -0500
Date: Fri, 18 Jan 2008 14:00:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: bugme-daemon@bugzilla.kernel.org, marciobuss@gmail.com
Subject: Re: [Bugme-new] [Bug 9564] New: Uninitialzed variable fields
 cvt.h_margin and cvt.v_margin
Message-Id: <20080118140055.fe862b78.akpm@linux-foundation.org>
In-Reply-To: <bug-9564-10286@http.bugzilla.kernel.org/>
References: <bug-9564-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 13:54:59 -0800 (PST)
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=9564
> 
>            Summary: Uninitialzed variable fields cvt.h_margin and
>                     cvt.v_margin
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.23
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Video(Other)
>         AssignedTo: drivers_video-other@kernel-bugs.osdl.org
>         ReportedBy: marciobuss@gmail.com
> 
> 
> The errors can be found at drivers/video/fbcvt.c as follows:
> 
> (1) the test "if (margin)" at line 310 evaluates to false,
> (2) this makes the test "if (cvt.flags & FB_CVT_FLAG_MARGINS)" at line 352
>     to evaluate to false as well
> (3) now cvt.h_margin is uninitialized at line 359, 368, and 370, and
>     cvt.v_margin is uninitizalied at line 371.
> 
> In other words, both cvt.v_margin and cvt.h_margin are initialized conditinally
> but used unconditionally. This bug is a false positive only if the parameter
> "margins" at line 304 is never 0. However, this would make the test at line
> 310 unnecessary -- anyone looking at the code is miled into believing that
> 0 is a legal value for "margins". This means the code does require some change
> in my humble opinion.
> 

Could someone please take a look at this?
