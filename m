Return-Path: <linux-kernel-owner+w=401wt.eu-S1751766AbZGSWFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbZGSWFA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 18:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbZGSWE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 18:04:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50201 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZGSWE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 18:04:58 -0400
Date: Mon, 20 Jul 2009 00:04:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Julia Lawall <julia@diku.dk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/10] drivers/hid: Move dereferences below a NULL test
In-Reply-To: <Pine.LNX.4.64.0907191725530.16542@ask.diku.dk>
Message-ID: <alpine.LNX.2.00.0907200004310.11648@wotan.suse.de>
References: <Pine.LNX.4.64.0907191725530.16542@ask.diku.dk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jul 2009, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> If the NULL test is necessary, then the dereferences should be moved below
> the NULL test.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> type T;
> expression E,E1;
> identifier i,fld;
> statement S;
> @@
> 
> - T i = E->fld;
> + T i;
>   ... when != E=E1
>       when != i
>   if (E == NULL||...) S
> + i = E->fld;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Good catch, applied, thanks Julia.

-- 
Jiri Kosina
SUSE Labs
