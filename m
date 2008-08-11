Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbYHKHI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbYHKHI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 03:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbYHKHIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 03:08:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbYHKHIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 03:08:48 -0400
Message-ID: <489FE56E.1080707@redhat.com>
Date: Mon, 11 Aug 2008 09:08:30 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Glauber de Oliveira Costa <glommer@gmail.com>,
       Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: Use of barriers in pvclock ABI
References: <489CA3DA.1090400@goop.org>
In-Reply-To: <489CA3DA.1090400@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> However, the pvclock_clocksource_read() implementation is
> over-engineered, because it checks for an odd version and uses very
> strong rmb() barriers (which generates either an "lfence" or "lock add
> $0, (%esp)").
> 
> If we're happy to guarantee as an ABI issue that the record will never
> be updated cross-cpu, then we can make the barriers simply barrier() and
> just check for (src->version != dst->version).
> 
> Is that OK with you, or do you want to leave open the possibility of
> doing cross-cpu time updates?

Due to the TSC being involved here I don't expect cross-cpu time updates
will ever happen.  IMHO it is fine to change that.

cheers,
  Gerd

-- 
http://kraxel.fedorapeople.org/xenner/
