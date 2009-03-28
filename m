Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbZC1JGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbZC1JGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 05:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751227AbZC1JGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 05:06:11 -0400
Received: from iona.labri.fr ([147.210.8.143]:59964 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbZC1JGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 05:06:10 -0400
X-Greylist: delayed 1153 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Mar 2009 05:06:10 EDT
Message-ID: <49CDE401.2020502@inria.fr>
Date: Sat, 28 Mar 2009 09:46:57 +0100
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Eric Anholt <eric@anholt.net>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: DRM lock ordering fix series
References: <1238017510-26784-1-git-send-email-eric@anholt.net>	 <87ocvnmhqx.fsf@basil.nowhere.org>	 <1238170767.8275.2397.camel@gaiman.anholt.net>	 <1238171805.8275.2434.camel@gaiman.anholt.net>	 <20090327181018.GC11935@one.firstfloor.org>	 <1238184629.625.44.camel@gaiman.anholt.net> <1238201922.4039.403.camel@laptop>
In-Reply-To: <1238201922.4039.403.camel@laptop>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Also note that doing large gup() with gup_fast() will be undesirable due
> to it disabling IRQs. So iterating say several MB worth of pages will
> hurt like crazy. Currently all gup_fast() users do a single page lookup.
>   

In 2.6.29, fs/bio.c:955, fs/direct-io.c:153 and fs/splice.c:1222 do
multiple-pages lookup at once. The latter might be limited to 16 pages
because of the pipe-depth, I don't know about the formers.

Is there some sort of reasonable limit? A couple dozens pages at once maybe?

Brice

