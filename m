Return-Path: <linux-kernel-owner+w=401wt.eu-S1161382AbXEBDgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161382AbXEBDgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 23:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161255AbXEBDgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 23:36:41 -0400
Received: from smtp-out.google.com ([216.239.33.17]:17155 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161202AbXEBDgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 23:36:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=QP+nN2dfZoXImkXw8pep0kW9ITvedsI6UrEQ1NUslKankAVJrh2c0hrBdgTpw/+gX
	6SghrpM7fKOt62c4Shjug==
Message-ID: <6599ad830705012036g21cc8470nff246e146b1e4023@mail.gmail.com>
Date: Tue, 1 May 2007 20:36:29 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [patch] cpusets: allow empty {cpus,mems}_allowed to be set for unpopulated cpuset
Cc: "David Rientjes" <rientjes@google.com>, torvalds@linux-foundation.org,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070501202201.6903d922.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705011714490.6376@chino.kir.corp.google.com>
	 <20070501202201.6903d922.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/07, Paul Jackson <pj@sgi.com> wrote:
> Why do you need this?  It adds a little more code, and changes
> semantics a little bit, so I'd think it should have at least a
> little bit of justfication.

We have cases where we'd like to be able to clear the memory nodes
away from a (temporarily) empty cpuset without actually deleting the
directory - there's really no reason for the interface to stop people
from doing that as far as I can see. Otherwise the only way to reclaim
the node for a different sibling is to delete the cpuset.

>
>
> +       if (!*buf) {
> +               cpus_clear(trialcs.cpus_allowed);
>
> Won't the above code fail if someone does:
>
>         echo > /dev/cpuset/foobar/mems
>
> Just guessing, but I'd expect buf[] to contain a newline char,
> not just a zero length string, at this point.

Yes, but that's arguably an artefact of the user using the wrong tool
to update the cpu/node set. Doing "echo -n > /dev/cpuset/foobar/mems"
has the expected effect.

Paul
