Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbZAZT55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbZAZT55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbZAZT5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:57:49 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46190 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751500AbZAZT5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:57:48 -0500
Date: Mon, 26 Jan 2009 19:56:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: balbir@linux.vnet.ibm.com
Cc: Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       Arve Hj?nnev?g <arve@android.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Menage <menage@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Message-ID: <20090126195622.1d5bf488@lxorguk.ukuu.org.uk>
In-Reply-To: <20090126195431.GC504@balbir.in.ibm.com>
References: <200901211638.23101.knikanth@suse.de>
	<20090126195431.GC504@balbir.in.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 01:24:31 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Nikanth Karthikesan <knikanth@suse.de> [2009-01-21 16:38:21]:
> 
> > As Alan Cox suggested/wondered in this thread, 
> > http://lkml.org/lkml/2009/1/12/235 , this is a container group based approach 
> > to override the oom killer selection without losing all the benefits of the 
> > current oom killer heuristics and oom_adj interface.
> > 
> > It adds a tunable oom.victim to the oom cgroup. The oom killer will kill the 
> > process using the usual badness value but only within the cgroup with the 
> > maximum value for oom.victim before killing any process from a cgroup with a 
> > lesser oom.victim number. Oom killing could be disabled by setting 
> > oom.victim=0.
> 
> Looking at the patch, I wonder if it is time for user space OOM
> notifications that were discussed during the containers mini-summit.
> The idea is to inform user space about OOM's and let user space take
> action, if no action is taken, the default handler kicks in.

The OLPC folks (Marcelo I believe) posted code for this and I believe
OLPC is using this functionality internally so that under memory pressure
(before we actually hit OOM) programs can respond by doing stuff like
evicting caches.
