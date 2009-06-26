Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbZFZMrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbZFZMrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 08:47:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbZFZMrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 08:47:06 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:42954 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbZFZMrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 08:47:05 -0400
Date: Fri, 26 Jun 2009 16:47:05 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, maximilian attems <max@stro.at>,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: >= 2.6.30 broken alpha smp build
Message-ID: <20090626124705.GA25147@jurassic.park.msu.ru>
References: <20090625090842.GA17936@stro.at> <20090625115423.6a31b49c.akpm@linux-foundation.org> <4A4419AA.2040400@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4419AA.2040400@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 09:43:22AM +0900, Tejun Heo wrote:
> The __used attribute is dropped by a patch in percpu patchset as it
> caused build warning on my test builds and wasn't even effective
> as-was (overriden by later NULL definition).  Ivan, any ideas why it's
> there?

It was intended for suppressing the compiler warnings about "unused"
static per-cpu variables, as they were only referenced inside the asm code.

Now it seems to be broken with DECLARE_PER_CPU thing, so I think your
patch that kills __used attribute should go in as a compile fix ASAP -
we can live with a few compile warnings until the rest of percpu patchset
gets merged.

Ivan.
