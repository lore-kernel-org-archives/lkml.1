Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbXGVR2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbXGVR2b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 13:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbXGVR2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 13:28:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42193 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbXGVR2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 13:28:20 -0400
Subject: Re: Power Management framework proposal
From: Arjan van de Ven <arjan@infradead.org>
To: david@lang.hm
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 22 Jul 2007 10:26:28 -0700
Message-Id: <1185125189.2714.13.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-21 at 23:49 -0700, david@lang.hm wrote:

> this approach would allow the transition of ALL drivers to the new mode of 
> operation in one fell swoop, and then adding additional power management 
> features is just adding to the existing list rather then implementing new 
> functions.


I have a concern with this approach though. It seems to assume that
there is one global thing somewhere that sets the system state; in my
experience that is the wrong approach; in fact there is a very definite
evidence that there are many decisions on power that are to be made
local at a high frequency. An example of this is the processor speed;
the ondemand governer does exactly this for the cpus that can switch
speeds fast; it's just impossible to beat such a local, fast decision
with anything on a global scale.

On the other hand, some things (the high level goals and constraints)
are obviously global.

However, your design seems to want to put the low level settings in a
global thing, and that is just a mistake.


