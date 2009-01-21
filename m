Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbZAUNRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbZAUNRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 08:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbZAUNRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 08:17:41 -0500
Received: from tservice.net.ru ([195.178.208.66]:45283 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273AbZAUNRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 08:17:40 -0500
Date: Wed, 21 Jan 2009 16:17:39 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Message-ID: <20090121131739.GB4997@ioremap.net>
References: <200901211638.23101.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901211638.23101.knikanth@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 04:38:21PM +0530, Nikanth Karthikesan (knikanth@suse.de) wrote:
> As Alan Cox suggested/wondered in this thread, 
> http://lkml.org/lkml/2009/1/12/235 , this is a container group based approach 
> to override the oom killer selection without losing all the benefits of the 
> current oom killer heuristics and oom_adj interface.
> 
> It adds a tunable oom.victim to the oom cgroup. The oom killer will kill the 
> process using the usual badness value but only within the cgroup with the 
> maximum value for oom.victim before killing any process from a cgroup with a 
> lesser oom.victim number. Oom killing could be disabled by setting 
> oom.victim=0.

Looks good, except that in some conditions (everyone has zero for
example) victim=0 does not disalbe oom-killer because of !chosen
part of the condition.

-- 
	Evgeniy Polyakov
