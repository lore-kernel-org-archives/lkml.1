Return-Path: <linux-kernel-owner+w=401wt.eu-S933144AbXCPQbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144AbXCPQbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933193AbXCPQbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:31:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38772 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933144AbXCPQbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:31:08 -0400
Subject: Re: [RFC][PATCH 2/7] RSS controller core
From: Dave Hansen <hansendc@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, menage@google.com,
       Andrew Morton <akpm@linux-foundation.org>, xemul@sw.ru
In-Reply-To: <m1mz2enh0u.fsf@ebiederm.dsl.xmission.com>
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>
	 <20070306140036.4e85bd2f.akpm@linux-foundation.org>
	 <45F3F581.9030503@sw.ru>
	 <20070311045111.62d3e9f9.akpm@linux-foundation.org>
	 <20070312010039.GC21861@MAIL.13thfloor.at>
	 <1173724979.11945.103.camel@localhost.localdomain>
	 <20070312224129.GC21258@MAIL.13thfloor.at>
	 <20070312220439.677b4787.akpm@linux-foundation.org>
	 <1173806793.6680.44.camel@localhost.localdomain>
	 <20070313190931.1417c012@lxorguk.ukuu.org.uk>
	 <m1mz2enh0u.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 09:31:00 -0700
Message-Id: <1174062660.8184.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 18:55 -0600, Eric W. Biederman wrote:
> To create a DOS attack.
> 
> - Allocate some memory you know your victim will want in the future,
>   (shared libraries and the like).
> - Wait until your victim is using the memory you allocated.
> - Terminate your memory resource group.
> - Victim is pushed over memory limits by your exiting.
> - Victim can no longer allocate memory
> - Victim dies
> 
> It's not quite that easy unless your victim calls mlockall(MCL_FUTURE),
> but the potential is clearly there.
> 
> Am I missing something?  Or is this fundamental to any first touch scenario?
> 
> I just know I have problems with first touch because it is darn hard to
> reason about.

I think it's fundamental to any case where two containers share the use
of the page, but either one _can_ be charged but does not receive a
_full_ charge for it.

I don't think it's uniquely associated with first-touch schemes.

The software zones approach where there would be a set of "shared" zones
would not have this problem, because any sharing would have to occur on
data on which neither one was being charged.

http://linux-mm.org/SoftwareZones

-- Dave

