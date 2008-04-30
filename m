Return-Path: <linux-kernel-owner+w=401wt.eu-S1763422AbYD3STP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763422AbYD3STP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757735AbYD3SS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:18:59 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:4503 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbYD3SS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:18:58 -0400
To: Soumyadip Das Mahapatra <dip_kernel@yahoo.co.in>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Improved Swaping Method In sort.c
From: Andi Kleen <andi@firstfloor.org>
References: <191572.86791.qm@web94110.mail.in2.yahoo.com>
Date: Wed, 30 Apr 2008 20:17:22 +0200
In-Reply-To: <191572.86791.qm@web94110.mail.in2.yahoo.com> (Soumyadip Das Mahapatra's message of "Wed, 30 Apr 2008 23:39:09 +0530 (IST)")
Message-ID: <87fxt3gqbx.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Apr 2008 18:10:29.0093 (UTC) FILETIME=[78D00950:01C8AAED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soumyadip Das Mahapatra <dip_kernel@yahoo.co.in> writes:

> But this code saves memory equaling two integers. What about that ?

It won't because the compiler uses registers not memory for the
temporary of course. In fact your version will cause more memory
accesses because the compiler doesn't know that a and b do not alias
each other, so it cannot cache the immediate value and has to always
go through memory. The difference will not be large on x86 because L1
cache accesses are reasonably fast, but they're still much slower than
a register access.

-Andi
