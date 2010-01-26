Return-Path: <linux-kernel-owner+w=401wt.eu-S1755017Ab0AZTWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab0AZTWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864Ab0AZTWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:22:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55080 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab0AZTWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:22:01 -0500
Subject: Re: perf report for .ko files
From: Peter Zijlstra <peterz@infradead.org>
To: john smith <whalajam@yahoo.com>
Cc: linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <666103.59126.qm@web55005.mail.re4.yahoo.com>
References: <666103.59126.qm@web55005.mail.re4.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jan 2010 20:21:55 +0100
Message-ID: <1264533715.4283.1961.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 16:34 -0800, john smith wrote:
> How can "perf report" be used to get info on (only) the specific manually loadable modules?
> Driver entry points are reported but without full breakdown (on all the calls).

Since its sampling it could be a function is just not hit, another
possibility is inlining of functions, we simply cannot see inlined
functions.

> If "--symbols" option is used, most of the symbols are not found.
> ("--dsos" doesn't seem to help)

I'm not a big module user, but I think --dsos should work, if not feel
free to send a patch to rectify this situation.

--dsos does appear to work on my laptop (where I have iwlagn as a module
since it sometimes needs a reload to start working, which is hard when
build in).

perf report --dsos "[iwlagn]"

does indeed give me all iwlagn hits, albeit without symbol information,
not sure why that is, /proc/kallsyms does seem to include some iwlagn
symbols.

Arnaldo might have a clue.

