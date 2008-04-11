Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbYDKHn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbYDKHn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 03:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756084AbYDKHnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 03:43:51 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:23750 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbYDKHnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 03:43:50 -0400
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: set_cyc2ns_scale() remove tsc_now and ns_now
From: Andi Kleen <andi@firstfloor.org>
References: <200804102331.11815.fzu@wemgehoertderstaat.de>
Date: Fri, 11 Apr 2008 09:42:48 +0200
In-Reply-To: <200804102331.11815.fzu@wemgehoertderstaat.de> (Karsten Wiese's message of "Thu, 10 Apr 2008 23:31:11 +0200")
Message-ID: <873apsn8g7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Apr 2008 07:36:03.0846 (UTC) FILETIME=[B24F0A60:01C89BA6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten Wiese <fzu@wemgehoertderstaat.de> writes:

> Both are unused and the functions rdtscll() and __cycles_2_ns() don't have
> side-effects.

I don't think you should remove those. At some point the offset
needs to be reset when the frequency scale changes for obvious reasons, 
and that needs to be fixed, not the code removed. Right now you'll get
scheduling inconsistencies during frequency changes on 
!constant_tsc CPUs.

(actually it is still the wrong time -- really needs a grace 
period during which the TSC is not used
ftp://firstfloor.org/pub/ak/quilt/patches/sched-clock implemented
some of these ideas against an older kernel)

-Andi

