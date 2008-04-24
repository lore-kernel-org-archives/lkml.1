Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbYDXNaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbYDXNaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 09:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYDXNaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 09:30:01 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:48314 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYDXNaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 09:30:00 -0400
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH 0/3] Skip I/O merges when disabled
From: Andi Kleen <andi@firstfloor.org>
References: <480F8936.5030406@hp.com>
Date: Thu, 24 Apr 2008 15:29:05 +0200
In-Reply-To: <480F8936.5030406@hp.com> (Alan D. Brunelle's message of "Wed, 23 Apr 2008 15:08:38 -0400")
Message-ID: <87ve27gz4u.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Apr 2008 13:22:15.0948 (UTC) FILETIME=[36D104C0:01C8A60E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Alan D. Brunelle" <Alan.Brunelle@hp.com> writes:

> The block I/O + elevator + I/O scheduler code spends a lot of time
> trying to merge I/Os -- rightfully so under "normal" circumstances.
> However, if one were to know that the incoming I/O stream was /very/
> random in nature, the cycles are wasted. (This can be the case, for
> example, during OLTP-type runs.)
>
> This patch stream adds a per-request_queue tunable that (when set)
> disables merge attempts, thus freeing up a non-trivial amount of CPU cycles.

It sounds interesting. But explicit tunables are always bad because
they will be only used by a elite few. Do you think it would be
possible instead to keep some statistics on how successfull merging is and
when the success rate is very low disable it automatically for some
time until a time out?

This way nearly everybody could get most of the benefit from this
change.

-Andi
