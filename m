Return-Path: <linux-kernel-owner+w=401wt.eu-S1759126AbYAPWg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126AbYAPWg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757449AbYAPWgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:36:09 -0500
Received: from saeurebad.de ([85.214.36.134]:36794 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758594AbYAPWgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:36:06 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
References: <87lk6pvii0.fsf@saeurebad.de>
	<alpine.LFD.1.00.0801161026550.2806@woody.linux-foundation.org>
	<87odblct19.fsf@saeurebad.de>
	<Pine.LNX.4.64.0801161419290.11922@schroedinger.engr.sgi.com>
Date: Wed, 16 Jan 2008 23:37:04 +0100
In-Reply-To: <Pine.LNX.4.64.0801161419290.11922@schroedinger.engr.sgi.com>
	(Christoph Lameter's message of "Wed, 16 Jan 2008 14:20:50 -0800
	(PST)")
Message-ID: <87ir1tcs8f.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Christoph Lameter <clameter@sgi.com> writes:

> On Wed, 16 Jan 2008, Johannes Weiner wrote:
>
>> So if I got it right and you actually modify the memory you only got a
>> const pointer to, you reach a level where you _have to_ break this
>> policy and cast to a non-const pointer, as it is currently done in
>> kfree().  No?
>
> Correct and we have gcc 4.2 currently spitting out warnings because of 
> casting to non const. Any idea how to convince gcc that this is okay?

Two dirty hacks where gcc at least does not complain:

	void *y = (void *)x;

and then pass y, or passing

	*(void **)&x

directly.

Both approaches seem just too ugly to silence a bogus warning.

	Hannes
