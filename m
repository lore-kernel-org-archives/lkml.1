Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbZGBMKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbZGBMKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 08:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbZGBMKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 08:10:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:58882 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbZGBMKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 08:10:39 -0400
Subject: Re: [patch 0/4] perf_counter tools: support annotation of live
 kernel modules
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246519076.6384.22.camel@marge.simson.net>
References: <1246514639.13293.40.camel@marge.simson.net>
	 <20090702064712.GA26690@elte.hu>
	 <1246519076.6384.22.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 14:10:17 +0200
Message-Id: <1246536617.4752.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 09:17 +0200, Mike Galbraith wrote:

>  I've been pondering a perf archive tool
> that would package everything that's needed to do analysis on a
> different box.  One big problem though, is that while you can easily
> package vmlinux and modules, what about all the userland binaries?  A
> large perf.data and/or debug info binaries can easily make transport
> impractical enough.

I would simply extend the current file header with another section in
which we do a structured storage of the data structures we currently
build in perf-report. That is, the dso and symbol bits.

If we then run perf-report on a file containing such a section we read
that data instead of trying to locate them the regular way.



