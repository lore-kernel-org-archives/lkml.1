Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbYAUR3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbYAUR3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 12:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYAUR27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 12:28:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:5493 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYAUR26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 12:28:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=IYl2wmIDGbmMzHITvUrFQZwPmXa32s4+6Z3x6mLcFOV+2yPFL+rReFbqePDzwztP3dVOVFTn37jl7Guek2OgIpZk9aTuo2G2tAnfwmrPMVHWzPTBsTwWOCmPddoUpsZRI57qi3apWuY9byjbFkj0ztDhOa9yL08M+HmDSKVrGkw=
Date: Mon, 21 Jan 2008 20:28:39 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, marciobuss@gmail.com
Subject: Re: [Bugme-new] [Bug 9564] New: Uninitialzed variable fields
	cvt.h_margin and cvt.v_margin
Message-ID: <20080121172839.GB6722@cvg>
References: <bug-9564-10286@http.bugzilla.kernel.org/> <20080118140055.fe862b78.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118140055.fe862b78.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrew Morton - Fri, Jan 18, 2008 at 02:00:55PM -0800]
| On Fri, 14 Dec 2007 13:54:59 -0800 (PST)
| bugme-daemon@bugzilla.kernel.org wrote:
| 
| > http://bugzilla.kernel.org/show_bug.cgi?id=9564
| > 
| >            Summary: Uninitialzed variable fields cvt.h_margin and
| >                     cvt.v_margin
| >            Product: Drivers
| >            Version: 2.5
| >      KernelVersion: 2.6.23
| >           Platform: All
| >         OS/Version: Linux
| >               Tree: Mainline
| >             Status: NEW
| >           Severity: normal
| >           Priority: P1
| >          Component: Video(Other)
| >         AssignedTo: drivers_video-other@kernel-bugs.osdl.org
| >         ReportedBy: marciobuss@gmail.com
| > 
| > 
| > The errors can be found at drivers/video/fbcvt.c as follows:
| > 
| > (1) the test "if (margin)" at line 310 evaluates to false,
| > (2) this makes the test "if (cvt.flags & FB_CVT_FLAG_MARGINS)" at line 352
| >     to evaluate to false as well
| > (3) now cvt.h_margin is uninitialized at line 359, 368, and 370, and
| >     cvt.v_margin is uninitizalied at line 371.
| > 
| > In other words, both cvt.v_margin and cvt.h_margin are initialized conditinally
| > but used unconditionally. This bug is a false positive only if the parameter
| > "margins" at line 304 is never 0. However, this would make the test at line
| > 310 unnecessary -- anyone looking at the code is miled into believing that
| > 0 is a legal value for "margins". This means the code does require some change
| > in my humble opinion.
| > 
| 
| Could someone please take a look at this?

unfortunelly, it's not really obvious what is the right way of
calculation. *should* the 1.8% margin be involved in calculation
all the time or 0 is legal too?

		- Cyrill -
