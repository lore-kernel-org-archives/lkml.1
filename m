Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbYJWOMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbYJWOMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbYJWOMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:12:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36202 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751428AbYJWOMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:12:33 -0400
Date: Thu, 23 Oct 2008 09:12:32 -0500
From: Robin Holt <holt@sgi.com>
To: Rick Jones <rick.jones2@hp.com>
Cc: Petr Tesarik <ptesarik@suse.cz>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, tee@sgi.com
Subject: Re: [PATCH 0/2] enable irqs when waiting for rwlocks
Message-ID: <20081023141232.GC8483@sgi.com>
References: <1224664414.4430.33.camel@elijah.suse.cz> <48FF6389.9050408@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FF6389.9050408@hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 10:31:53AM -0700, Rick Jones wrote:
> Petr Tesarik wrote:
>> Hello,
>>
>> SGI has observed that on large systems, interrupts are not serviced for
>> a long period of time when waiting for a rwlock. The following patch
>> series re-enables irqs while waiting for the lock, resembling the code
>> which is already there for spinlocks.
>
> Perhaps I'm just out in left field, but that (and the similar behaviour  
> for obtaining a spinlock?) feels like treating a symptom rather than a  
> root cause where the root cause would appear to be long lock hold  
> times/contention?

Sometimes lock contention on large systems will take a few seconds to
pass.  This is normal behavior which simply can not be eliminated.  For
those cases, we need to rely upon being able to re-enable interrupts and
allowing other operations to continue normally.  Simply put, in some
cases, nothing more can be done.

Thanks,
Robin
