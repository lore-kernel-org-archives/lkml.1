Return-Path: <linux-kernel-owner+w=401wt.eu-S1763598AbXHLDpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763598AbXHLDpb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 23:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756321AbXHLDpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 23:45:23 -0400
Received: from mail.ocs.com.au ([203.34.248.175]:22335 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbXHLDpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 23:45:22 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Aug 2007 23:45:22 EDT
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
From: Keith Owens <kaos@ocs.com.au>
To: casey@schaufler-ca.com
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel 
In-reply-to: Your message of "Sat, 11 Aug 2007 10:57:31 MST."
             <46BDF88B.2060301@schaufler-ca.com> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 12 Aug 2007 13:45:18 +1000
Message-ID: <3351.1186890318@ocs10w.ocs.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler (on Sat, 11 Aug 2007 10:57:31 -0700) wrote:
>Smack is the Simplified Mandatory Access Control Kernel.
>
> [snip]
>
>Smack defines and uses these labels:
>
>    "*" - pronounced "star"
>    "_" - pronounced "floor"
>    "^" - pronounced "hat"
>    "?" - pronounced "huh"
>
>The access rules enforced by Smack are, in order:
>
>1. Any access requested by a task labeled "*" is denied.
>2. A read or execute access requested by a task labeled "^"
>   is permitted.
>3. A read or execute access requested on an object labeled "_"
>   is permitted.
>4. Any access requested on an object labeled "*" is permitted.
>5. Any access requested by a task on an object with the same
>   label is permitted.
>6. Any access requested that is explicitly defined in the loaded
>   rule set is permitted.
>7. Any other access is denied.

Some security systems that have the concept of "no default access"
(task labeled "*") also allow access by those tasks but only if there
is an explicit rule giving access to the task.  IOW, rule 6 is applied
before rule 1.  In my experience this simplifies special cases where a
task should only have access to a very small set of resources.  I'm
curious why smack goes the other way?

