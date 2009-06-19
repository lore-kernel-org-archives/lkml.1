Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbZFSC1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbZFSC1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 22:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbZFSC1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 22:27:09 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:41695 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbZFSC1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 22:27:08 -0400
Date: Fri, 19 Jun 2009 11:26:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rmap: fixup page_referenced() for nommu systems
Message-ID: <20090619022616.GA16806@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	David McCullough <davidm@snapgear.com>,
	Greg Ungerer <gerg@uclinux.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1245371813-30954-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245371813-30954-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 08:36:53PM -0400, Mike Frysinger wrote:
> After the recent changes that went into mm/vmscan.c to overhaul stuff, we
> ended up with these warnings on no-mmu systems:
> mm/vmscan.c: In function ???shrink_page_list???:
> mm/vmscan.c:580: warning: unused variable ???vm_flags???
> mm/vmscan.c: In function ???shrink_active_list???:
> mm/vmscan.c:1294: warning: ???vm_flags??? may be used uninitialized in this function
> mm/vmscan.c:1242: note: ???vm_flags??? was declared here
> 
> This is because the no-mmu function defines page_referenced() to work on
> the first argument only (the page).  It does not clear the vm_flags given
> to it because for no-mmu systems, they never actually get utilized.  Since
> that is no longer strictly true, we need to set vm_flags to 0 like everyone
> else so gcc can do proper dead code elimination without annoying us with
> unused warnings.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Looks ok to me.

Acked-by: Paul Mundt <lethal@linux-sh.org>
