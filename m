Return-Path: <linux-kernel-owner+w=401wt.eu-S933716AbYBHLjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716AbYBHLjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 06:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYBHLje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 06:39:34 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:41995 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbYBHLjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 06:39:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EFBxRZp1aJbOAplM4bxTNYgvoqJDlAoHSvMkgeMX5CkhzzCN+bcxr7djJCZ3OLrte8eg/bu70SZj5kkgG7VopSmpOmEmyNph2Q/ZDBma1SgLqf1IyGH/28eqSQcUvdQ8TViUcjO3q64se9x0f20Sm+UUVYsa12EgWcA6YOPSky0=
Message-ID: <84144f020802080339o5f9442f7obc0a1de0bd688b93@mail.gmail.com>
Date: Fri, 8 Feb 2008 13:39:32 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH 1/2] kmemcheck v3
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Richard Knutsson" <ricknu-0@student.ltu.se>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080208121012.GF4745@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47AB79D4.2070605@gmail.com>
	 <20080208115542.GD4745@one.firstfloor.org>
	 <84144f020802080331j5bc01bc6naf1fe0192aadf70b@mail.gmail.com>
	 <20080208121012.GF4745@one.firstfloor.org>
X-Google-Sender-Auth: 807c8db8e05680b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Feb 8, 2008 2:10 PM, Andi Kleen <andi@firstfloor.org> wrote:
> It's probably tricky; there are all kinds of hidden page faults
> on x86 on data structures allocated as pages (e.g. GDT, LDT [which
> is sometimes kmalloc too], stack etc.)

Aah, I see. We can annotate those callers to disable the page faulting
but maybe that's not practical, dunno. Perhaps it's not such a big
problem to track slab objects only as those contain most of the
interesting ones anyway...
