Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab0CICdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 21:33:47 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:52879 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab0CICdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 21:33:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vfms5R1+75HKCbdO8Ji8SubFbUySzLYE3AMxN3RG2Nt2vy52sDxWy/4YKpYZ3ZVsq5
         wbfm8AsYm2Y/jo9w9bn2RHwb1pFpFe9S+3elkTuxJovHNE5KM0Y+c50QKZfABlvgvnp3
         3cyTAdxJtBu7cKT/2kAdU607BV0Y8VrU8kPtk=
MIME-Version: 1.0
In-Reply-To: <20100309095830.7d4a744d.kamezawa.hiroyu@jp.fujitsu.com>
References: <30859.1268056796@redhat.com> <20100309095830.7d4a744d.kamezawa.hiroyu@jp.fujitsu.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 8 Mar 2010 21:33:22 -0500
Message-ID: <8bd0f97a1003081833s2e8527d7pd1e0b427ae76020@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH] fix sync_mm_rss in nommu (Was Re: sync_mm_rss() 
	issues
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 8, 2010 at 19:58, KAMEZAWA Hiroyuki wrote:
> David-san, could you check this ?
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Fix breakage in NOMMU build
>
> commit 34e55232e59f7b19050267a05ff1226e5cd122a5 added sync_mm_rss()
> for syncing loosely accounted rss counters. It's for CONFIG_MMU but
> sync_mm_rss is called even in NOMMU enviroment (kerne/exit.c, fs/exec.c).
> Above commit doesn't handle it well.
>
> This patch changes
>  SPLIT_RSS_COUNTING depends on SPLIT_PTLOCKS && CONFIG_MMU
>
> And for avoid unnecessary function calls, sync_mm_rss changed to be inlined
> noop function in header file.

fixes Blackfin systems ...

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike
