Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbYDINLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbYDINLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 09:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbYDINLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 09:11:17 -0400
Received: from saeurebad.de ([85.214.36.134]:43984 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbYDINLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:11:17 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Andreas Grimm" <agrimm61@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: VM - a plenty of inactive memory
References: <cf40c6a90804090213u55491ceay9b211d75d74dc29c@mail.gmail.com>
Date: Wed, 09 Apr 2008 15:10:36 +0200
In-Reply-To: <cf40c6a90804090213u55491ceay9b211d75d74dc29c@mail.gmail.com>
	(Andreas Grimm's message of "Wed, 9 Apr 2008 11:13:56 +0200")
Message-ID: <874pabrx6b.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Andreas Grimm" <agrimm61@gmail.com> writes:

> Hello everybody,
>
> i got a weird problem with one of my servers. It's a Intel SR2500AL
> with 32GB of RAM.
> Looking at the memory usage of the system, something is going totally
> wrong. The crucial numbers from /proc/meminfo are:
>
> MemTotal: 33265916 kB
> MemFree: 416168 kB
> Inactive: 24630428 kB (24GB? whooaaa)
>
> Another system with only 16GB, same amount of users and load, shows a
> more normal behaviour:
>
> MemTotal: 16619808 kB
> MemFree: 6912676 kB
> Inactive: 1774364 kB
>
> Why does the 32GB-System have this plenty of inactive memory. Is there
> a way to find out, what the kernel is holding in readiness (that's the
> definition of inactive memory afaik)?

Inactive pages are marked in use but haven't been touched for some time.
These are candidates for memory reclaiming.

If nothing memory consuming happens, the kswapd should reclaim them back
eventually.

	Hannes
