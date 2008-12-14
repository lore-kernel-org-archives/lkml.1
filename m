Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYLNMmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYLNMmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 07:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYLNMmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 07:42:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:44263 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbYLNMmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 07:42:03 -0500
Subject: Re: "BUG: MAX_STACK_TRACE_ENTRIES too low!" - reason for concern?
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.7ea353e737215fa2@s5r6.in-berlin.de>
References: <tkrat.7ea353e737215fa2@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Sun, 14 Dec 2008 13:41:25 +0100
Message-Id: <1229258485.17130.8.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-12-14 at 02:38 +0100, Stefan Richter wrote:
> Is the following anything that anybody should do something about?
> 
> # unloading IEEE 1394 drivers (as slightly before linux1394-2.6.git)
> 
> Dec 14 01:23:24 stein ieee1394: Node removed: ID:BUS[3-00:1023]  GUID[00d0f5200800613d]
> Dec 14 01:23:24 stein ieee1394: Node removed: ID:BUS[2-00:1023]  GUID[0010dc5600fed2d4]
> Dec 14 01:23:24 stein ieee1394: Node removed: ID:BUS[1-01:1023]  GUID[0030bd051800064f]
> Dec 14 01:23:24 stein ieee1394: Node removed: ID:BUS[1-00:1023]  GUID[0012870035000f94]
> Dec 14 01:23:24 stein ieee1394: Node removed: ID:BUS[0-08:1023]  GUID[080028560000319b]
> 
> # reloading IEEE 1394 drivers (as in linux1394-2.6.git)
> 
> Dec 14 01:23:29 stein BUG: MAX_STACK_TRACE_ENTRIES too low!

lockdep resource allocation is pretty simple wrt to modules, it will not
re-use anything, therefore cycling modules will let it run out of its
resources pretty quickly.

I suppose one could go add all kinds of smart and complicate the whole
thing, but I'm not sure its worth it.

