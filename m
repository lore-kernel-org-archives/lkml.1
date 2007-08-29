Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbXH2XXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbXH2XXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 19:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbXH2XXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 19:23:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57026 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbXH2XXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 19:23:42 -0400
Date: Wed, 29 Aug 2007 16:23:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       mattilinnanvuori@yahoo.com
Subject: Re: [Bugme-new] [Bug 8957] New: Exported functions and variables
 should not be reachable by the outside of the module until module_init
 finishes
Message-Id: <20070829162335.8d5e8eca.akpm@linux-foundation.org>
In-Reply-To: <bug-8957-10286@http.bugzilla.kernel.org/>
References: <bug-8957-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2007 11:33:06 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8957
> 
>            Summary: Exported functions and variables should not be reachable
>                     by the outside of the module until module_init finishes
>            Product: Other
>            Version: 2.5
>      KernelVersion: 2.6.23-rc4
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Modules
>         AssignedTo: other_modules@kernel-bugs.osdl.org
>         ReportedBy: mattilinnanvuori@yahoo.com
> 
> 
> Problem Description: a module's exported functions can be called before before
> they are properly initialized by the module_init function.
> 
> Steps to reproduce: write a module that exports functions that require
> initialization by the module_init function to work correctly.
> 
> E.g. spin lock variables are no longer allowed to be initialized by C
> initializers of the module but only by spin_lock_init that can be called by the
> module_init function. If an exported function calls spin_lock before it is
> initialized, it deadlocks.
> 

ooh, nice bug ;)
