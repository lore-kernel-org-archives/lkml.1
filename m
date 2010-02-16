Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab0BPBK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 20:10:56 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38235 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab0BPBKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 20:10:54 -0500
Date: Tue, 16 Feb 2010 10:10:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>, David Howells <dhowells@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] ptrace: unify FDPIC implementations
Message-ID: <20100216011041.GB4889@linux-sh.org>
References: <1266280229-18469-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266280229-18469-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 07:30:29PM -0500, Mike Frysinger wrote:
> The Blackfin/FRV/SuperH guys all have the same exact FDPIC ptrace code in
> their arch handlers (since they were probably copied & pasted).  Since
> these ptrace interfaces are an arch independent aspect of the FDPIC code,
> unify them in the common ptrace code so new FDPIC ports don't need to copy
> and paste this fundamental stuff yet again.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> Acked-by: Roland McGrath <roland@redhat.com>
> Acked-by: David Howells <dhowells@redhat.com>
> Acked-by: Paul Mundt <lethal@linux-sh.org>

Just to follow up on this, this code obviously expects consistent entries
in mm_context_t. Presently include/asm-generic/mmu.h is aimed at nommu,
so it would probably be worthwhile stubbing in the FDPIC loadmap entries
there to make things easier for future ports.
