Return-Path: <linux-kernel-owner+w=401wt.eu-S1753488AbYDIN6C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbYDIN6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 09:58:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYDIN5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 09:57:52 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:41389 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYDIN5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:57:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o4v1tWi5643Kfikt6miamSQKSUvnMWId6o1WLiwSQJfEK1+5JKHnSEKzLZaxSbDDu9eTLqZY/lxZCsBMpWV9fkX67a7mMf6HgoM00988RKQ5C7EYds+4qt4J6gTYFLi7mg97USXwd8ZbZ8F/NHkyxC1e5qYYzQb4OBZCO6DP1IY=
Message-ID: <cf40c6a90804090657j7e76a84foeaf3c1c02d2a7b73@mail.gmail.com>
Date: Wed, 9 Apr 2008 15:57:48 +0200
From: "Andreas Grimm" <agrimm61@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: VM - a plenty of inactive memory
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <874pabrx6b.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cf40c6a90804090213u55491ceay9b211d75d74dc29c@mail.gmail.com>
	 <874pabrx6b.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

i know this. But why the kernel locks that memory for a so long time
(2 days now)? Is there a way to enforce the reclaiming? And how can i
find out, which process owns that memory. The problem is, that i can't
accept, that the free memory fell down to 50MB, when i have 24GB in
the nirvana. The system was recently very close to the awkward
situation to swap to disk, and i bet it will do so in the next few
days, because it happened before. Unintelligible, if one got that much
ram.

Bye, Andreas


2008/4/9, Johannes Weiner <hannes@saeurebad.de>:
> Hi,
>
>
>  "Andreas Grimm" <agrimm61@gmail.com> writes:
>
>  > Hello everybody,
>  >
>  > i got a weird problem with one of my servers. It's a Intel SR2500AL
>  > with 32GB of RAM.
>  > Looking at the memory usage of the system, something is going totally
>  > wrong. The crucial numbers from /proc/meminfo are:
>  >
>  > MemTotal: 33265916 kB
>  > MemFree: 416168 kB
>  > Inactive: 24630428 kB (24GB? whooaaa)
>  >
>  > Another system with only 16GB, same amount of users and load, shows a
>  > more normal behaviour:
>  >
>  > MemTotal: 16619808 kB
>  > MemFree: 6912676 kB
>  > Inactive: 1774364 kB
>  >
>  > Why does the 32GB-System have this plenty of inactive memory. Is there
>  > a way to find out, what the kernel is holding in readiness (that's the
>  > definition of inactive memory afaik)?
>
>
> Inactive pages are marked in use but haven't been touched for some time.
>  These are candidates for memory reclaiming.
>
>  If nothing memory consuming happens, the kswapd should reclaim them back
>  eventually.
>
>         Hannes
>
