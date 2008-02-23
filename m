Return-Path: <linux-kernel-owner+w=401wt.eu-S1762219AbYBWIDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762219AbYBWIDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757458AbYBWIDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:03:35 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757388AbYBWIDe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:03:34 -0500
Date: Sat, 23 Feb 2008 00:02:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?IklscG8gSuRydmluZW4i?= <ilpo.jarvinen@helsinki.fi>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC PATCH 8/8] Jhash in too big for inlining, move under lib/
Message-Id: <20080223000214.81b1390a.akpm@linux-foundation.org>
In-Reply-To: <1203515238-22848-9-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-2-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-3-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-4-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-5-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-6-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-7-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-8-git-send-email-ilpo.jarvinen@helsinki.fi>
	<1203515238-22848-9-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 15:47:18 +0200 "Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi> wrote:

> vmlinux.o:
>  62 functions changed, 66 bytes added, 10935 bytes removed, diff: -10869
> 
> ...+ these to lib/jhash.o:
>  jhash_3words: 112
>  jhash2: 276
>  jhash: 475
> 
> select for networking code might need a more fine-grained approach.

It should be possible to use a modular jhash.ko.  The things which you
have identified as clients of the jhash library are usually loaded as modules.

But in the case where someone does (say) NFSD=y we do need jhash.o linked into
vmlinux also.  This is doable in Kconfig but I always forget how.  Adrian, Sam
and Randy are the repositories of knowledge here ;)
