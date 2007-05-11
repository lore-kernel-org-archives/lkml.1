Return-Path: <linux-kernel-owner+w=401wt.eu-S1761764AbXEKIBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761764AbXEKIBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 04:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbXEKIBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 04:01:46 -0400
Received: from ip-svs-1.Informatik.Uni-Oldenburg.DE ([134.106.12.126]:48968
	"EHLO schlidder.svs.informatik.uni-oldenburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755328AbXEKIBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 04:01:45 -0400
X-Greylist: delayed 1215 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 May 2007 04:01:45 EDT
Date: Fri, 11 May 2007 09:41:26 +0200
From: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] "volatile considered harmful", take 2
Message-ID: <20070511074126.GA3037@titan.lahn.de>
Mail-Followup-To: Jonathan Corbet <corbet@lwn.net>,
	linux-kernel@vger.kernel.org
References: <6143.1178828419@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6143.1178828419@lwn.net>
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Thu, May 10, 2007 at 02:20:19PM -0600, Jonathan Corbet wrote:
...
> +++ b/Documentation/volatile-considered-harmful.txt
...
> +Consider a typical block of kernel code:
> +
> +    spin_lock(&the_lock);
> +    do_something_on(&shared_data);
                        ^^^^^^^^^^^
> +    do_something_else_with(&shared_data);
                               ^^^^^^^^^^^
> +    spin_unlock(&the_lock);
> +
> +If all the code follows the locking rules, the value of shared_data cannot
> +change unexpectedly while the_lock is held.  Any other code which might
> +want to play with that data will be waiting on the lock.  The spinlock
> +primitives act as memory barriers - they are explicitly written to do so -
> +meaning that data accesses will not be optimized across them.  So the
> +compiler might think it knows what will be in some_data, but the
s/some_data/shared_data/ ?                       ^^^^^^^^^

BYtE
Philipp
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de
