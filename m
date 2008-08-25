Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbYHYSPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbYHYSPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 14:15:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbYHYSOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 14:14:54 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:65499 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYHYSOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 14:14:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZcSWSoMPk61J3GYYXczclfHtlrRlDfwdr9zbSgN5FK8zPzayXxiKcSGDRx6+IGChcx
         ajZlxhZX7A/UeJ8KzK9NIN6VzfwKWeXEtNRdre+6JPqivU4rCe1HUFt1plqhhBPttRoz
         zz0FvpDYcwQ+F3WJP2qKWwK03LSwg8klpS8Nw=
Message-ID: <19f34abd0808251114p7b03b21oeb865b1706e095ef@mail.gmail.com>
Date: Mon, 25 Aug 2008 20:14:52 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080819124602.9e8e69f7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48A36838.3050309@hp.com>
	 <20080819124602.9e8e69f7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 9:46 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Thing is, the code *isn't* in an interrupt.  Something got screwed up.
>
> What can happen is that some code has a lock imbalance or a
> preempt_disable imbalance and it does preempt_disable() so many times
> that the counter overflows eight bits and starts to increment the
> softirq counter, then the hardirq counter, then in_interrupt() starts
> incorrectly returning true then blam.

Hm.

Config doesn't even have CONFIG_PREEMPT, so preempt_disable() should be a no-op.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
