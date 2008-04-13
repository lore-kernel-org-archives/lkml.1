Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbYDMQ7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbYDMQ7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 12:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYDMQ7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 12:59:46 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:25289 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbYDMQ7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 12:59:45 -0400
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       heukelum@fastmail.fm
Subject: Re: [PATCH] x86: always_inline wrapper for x86's test_bit
From: Andi Kleen <andi@firstfloor.org>
References: <20080413112308.GA23426@mailshack.com>
Date: Sun, 13 Apr 2008 18:58:30 +0200
In-Reply-To: <20080413112308.GA23426@mailshack.com> (Alexander van Heukelum's message of "Sun, 13 Apr 2008 13:23:08 +0200")
Message-ID: <87hce5wv2h.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Apr 2008 16:51:46.0124 (UTC) FILETIME=[A8AE68C0:01C89D86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum <heukelum@mailshack.com> writes:

> On x86, test_bit is currently implemented as a preprocessor macro. It
> uses gcc's __builtin_constant_p to determine if the bit position is 
> known at compile time and defers to one of two functions depending
> on that. This changes the same logic to an __always_inline wrapper
> instead.

Some old gccs didn't support __builtin_constant_p in inline properly,
that is why it was always written in macros.

Please double check with the oldest still supported gcc (3.2) if it 
really generates the expected code for the constant/non constant case.

-Andi
