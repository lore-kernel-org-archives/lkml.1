Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbZJEPfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbZJEPfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 11:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZJEPfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 11:35:45 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:48694 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751064AbZJEPfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 11:35:44 -0400
Date: Mon, 5 Oct 2009 11:28:55 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 12/20] Move early initialization of pagesets
 out of zone_wait_table_init()
In-Reply-To: <4ACA0EFD.4070607@kernel.org>
Message-ID: <alpine.DEB.1.10.0910051126370.16359@gentwo.org>
References: <20091001212521.123389189@gentwo.org> <20091001212559.879284755@gentwo.org> <4AC7279B.3050901@kernel.org> <alpine.DEB.1.10.0910051038410.16359@gentwo.org> <4ACA0A4F.3090004@kernel.org> <alpine.DEB.1.10.0910051105070.16359@gentwo.org>
 <4ACA0EFD.4070607@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, Tejun Heo wrote:

> > There are various arch implementations that do their own implementation of
> > setup_per_cpu_areas() at their own time (Check sparc and ia64 for
> > example).
>
> sparc is doing everything on setup_per_cpu_areas().  ia64 is an
> exception.  Hmmm... I really don't like scattering mostly unrelated
> init call to every setup_per_cpu_areas() implementation.  How about
> adding "static bool initialized __initdata" to the function and allow
> it to be called earlier when necessary (only ia64 at the moment)?

It would be best to consolidate all setup_per_cpu_areas() to work at the
same time during bootup. How about having a single setup_per_cpu_areas()
function and then within the function allow arch specific processing. Try
to share as much code as possible?

