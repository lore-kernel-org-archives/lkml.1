Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbYIYGH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbYIYGH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 02:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbYIYGHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 02:07:11 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:36147 "EHLO
	QMTA10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733AbYIYGHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:07:10 -0400
X-Authority-Analysis: v=1.0 c=1 a=qJl3jAXflj4A:10 a=OjkjO2y-e4IA:10
 a=4uOlucCFMxh5rItqBgwA:9 a=-Jt9Tx1taKRbT4p8-_8A:7
 a=b4i523rOK-WioxX114lWgn9Jjc8A:4 a=b8hG5vVbyAkA:10
Subject: [RFC PATCH 0/8] current relay cleanup patchset
From: Tom Zanussi <zanussi@comcast.net>
To: Martin Bligh <mbligh@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@suse.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>
In-Reply-To: <1222228215.7761.0.camel@charm-linux>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	 <1221869279.8359.31.camel@lappy.programming.kicks-ass.net>
	 <20080922140740.GB5279@in.ibm.com>
	 <1222094724.16700.11.camel@lappy.programming.kicks-ass.net>
	 <1222147545.6875.135.camel@charm-linux>
	 <33307c790809230700o4bf0d22fg8ab2dcb904f7d66c@mail.gmail.com>
	 <1222228215.7761.0.camel@charm-linux>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 01:07:05 -0500
Message-Id: <1222322825.6435.55.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the current relay cleanup patchset.  The first two patches make
the write path completely replaceable, the third adds flags along with
some related cleanup, and the next 5 remove the padding in several
stages. 

It's a work in progress, but because I wanted the intermediate stages to
actually work and not break anything, some of these patches, especially
05, are just temporary and will be removed in the next iteration.

I didn't have time to clean up the first 3 either - I'll also do that
the next time around.

Anyway, removing the padding has simplified the read/splice code
significantly; it's always been a source of headaches so I'm glad it's
gone, and it doesn't seem to have broken anything - a quick test using
blktrace in both read() and splice() modes didn't show any problems.

In the next round I plan to do vmap and sub-buffer removal.

Tom




