Return-Path: <linux-kernel-owner+w=401wt.eu-S1764368AbYETSaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764368AbYETSaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757457AbYETSaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:30:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46051 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356AbYETSaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:30:11 -0400
Message-ID: <483318AE.2090306@firstfloor.org>
Date: Tue, 20 May 2008 20:30:06 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/11] Add unlocked_fasync
References: <20080520528.793382059@firstfloor.org>	<20080520152843.CF4181B4205@basil.firstfloor.org> <20080520085830.22c99115@infradead.org>
In-Reply-To: <20080520085830.22c99115@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 20 May 2008 17:28:43 +0200 (CEST)
> Andi Kleen <andi@firstfloor.org> wrote:
> 
>> Add a new fops entry point to allow fasync without BKL. 
> 
> I (again) really don't like having another entry point for this...
> it'll stay around forever rather than doing this as one step and 
> move on.

Yes the goal is for it staying around forever, correct. And ->fasync()
will go instead.

Advantage is that out of tree drivers will be compile broken which I
consider an advantage. Yes I know Linus said earlier that's not
important to him, but in this case my standards are higher than his.

Also BTW if you're that worried about the audit not getting
finished then the result would be just that lots of lock_kernel()s
would stay around. Hardly better.

But cannot do that many drivers in one step.

My goal is to just audit the remaining ones and then remove ->fasync()
and unlocked_fasync stays. Will be hopefully not that far away, since
fasync is relatively easy. The conversions are mostly for me to keep
track which ones I audited.

-Andi




