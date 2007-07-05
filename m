Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbXGEAo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbXGEAo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 20:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbXGEAot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 20:44:49 -0400
Received: from ozlabs.org ([203.10.76.45]:57687 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671AbXGEAos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 20:44:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18060.16064.519060.755991@cargo.ozlabs.ibm.com>
Date: Thu, 5 Jul 2007 10:43:44 +1000
From: Paul Mackerras <paulus@samba.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: stern@rowland.harvard.edu, oliver@neukum.org, rjw@sisk.pl,
       mjg59@srcf.ucam.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
In-Reply-To: <E1I6ATN-0007QS-00@dorka.pomaz.szeredi.hu>
References: <Pine.LNX.4.44L0.0707041139100.25704-100000@netrider.rowland.org>
	<E1I6ATN-0007QS-00@dorka.pomaz.szeredi.hu>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi writes:

> OK, let me summarize the situation as I see it now: there are two
> camps, the pro-freezers and the anti-freezers.
> 
> Pro-freezers say:
> 
>   - don't remove the freezer, otherwise we'll have to deal with
>     numerous problems in drivers
> 
> Anti-freezers say:
> 
>   - let's remove the freezer, which causes numerous problems
> 
> Alan summerized the pro-freezer arguments well I think.  What are the
> anti-freezer arguments then?

1. The freezer cannot be guaranteed deadlock-free without constructing
   a dependency graph between tasks (both user and kernel), which is
   virtually impossible since the dependencies are not externally
   observable.

2. As a consequence of (1), we try to make a crude approximation of
   the graph by saying "only kernel threads that want to be frozen
   will be frozen" or some other similar statement.

3. However, (2) means that we can no longer guarantee that drivers
   will not get any I/O requests after their suspend method has been
   called, and therefore the freezer fails in its main objective.

4. We have an existence proof that reliable suspend can be achieved
   without the freezer.

To summarize, the argument is that the freezer is deadlock-prone and
ineffective.

Paul.
