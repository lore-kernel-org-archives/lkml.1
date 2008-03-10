Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbYCJQqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbYCJQqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbYCJQqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:46:40 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:14433 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbYCJQqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:46:40 -0400
To: Stephan Diestelhorst <langer_mann@web.de>
Cc: Ingo Molnar <mingo@elte.hu>, davej@codemonkey.org.uk,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Speedfreq-SMI call clobbers ECX
References: <200803051559.09962.langer_mann@web.de>
	<200803060951.12002.langer_mann@web.de>
	<20080306105603.GL13391@elte.hu>
	<200803101605.42251.langer_mann@web.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 10 Mar 2008 17:46:37 +0100
In-Reply-To: <200803101605.42251.langer_mann@web.de>
Message-ID: <87iqzu8r2q.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Mar 2008 16:40:06.0345 (UTC) FILETIME=[65891B90:01C882CD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Diestelhorst <langer_mann@web.de> writes:
> 
> New attempt with full clobbers, note that I deliberatly did not change
> the order of the output registers. Real output operands still preceede
> outputs used for potential clobbering.
> 
> I'm not too sure about the EBP push/pop frame, but as folks pointed
> out already, we should not trust the SMI code too much.

Be careful -- older gcc versions tend to abort for inline asm
that clobbers too many registers. Especially when the register
is already used (like ebp in a frame pointer enabled kernel) 

Make sure it at least works on the oldest supported gcc version 
(gcc 3.2) and with frame pointer on.

For asms with so many clobbers explicit push/pop is usually safer.

-Andi
