Return-Path: <linux-kernel-owner+w=401wt.eu-S1760300AbZFOJKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbZFOJKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZFOJKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:10:01 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:57673 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbZFOJKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:10:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YBW5QZwxh+SWuPni+Rkh2auLNGZXLJ2/ddLldsitQWpFnIeIBIX9/uBzWUb58eYM4x
         xqQUE9OGZKzOxKHVky+5XCvuc/FRgv/T/5C5nqczWbMyLBXzxkHXbOYAKPJQphmWOL3j
         kMrAzZKpAX+QhnbYVqa2qXdXnubW1nBlluZfE=
MIME-Version: 1.0
In-Reply-To: <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
Date: Mon, 15 Jun 2009 12:10:01 +0300
X-Google-Sender-Auth: 1a1ebd2014017c5e
Message-ID: <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       npiggin@suse.de, yinghai@kernel.org, benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 11:18 AM, Heiko
Carstens<heiko.carstens@de.ibm.com> wrote:
> I didn't look any deeper into this, but looks to me like doing something like
> schedule_work() this early isn't ok.
>
> This is the conversion that leads to the crash:
>
> -               alloc_bootmem_low(sizeof(struct raw3215_info));
> +               kzalloc(sizeof(struct raw3215_info), GFP_NOWAIT | GFP_DMA);
>
> Might be that I missed something. Maybe some special flag?

Btw, you should not need to use GFP_NOWAIT anymore and GFP_KERNEL
should be fine even during early boot.

                                   Pekka
