Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbZHLTRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbZHLTRL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 15:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZHLTRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 15:17:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39493 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbZHLTRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 15:17:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ZhjowJH4XlMTl8Re6ewXHEpqtpkQihvItqzvtWAWDAXfo05nYZQb96nh+fwXD16tW
	invssXm1xWYSF/kXcK8Lw==
Date: Wed, 12 Aug 2009 12:17:01 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vincent Li <macli@brc.ubc.ca>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mpm@selenic.com
Subject: Re: [PATCH] fs/proc/: fix input sanity check.
In-Reply-To: <alpine.DEB.1.00.0908121003180.21620@mail.selltech.ca>
Message-ID: <alpine.DEB.2.00.0908121208300.27880@chino.kir.corp.google.com>
References: <1250026466-8769-1-git-send-email-macli@brc.ubc.ca> <20090811150528.a9bc7719.akpm@linux-foundation.org> <alpine.DEB.1.00.0908121003180.21620@mail.selltech.ca>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, Vincent Li wrote:

> I re-read the clear_refs_write() in fs/proc/task_mmu.c, If I understand it 
> correctly, The old code takes  non-zero string 
> from userspace and convert it to unsigned long interger value. for 

strict_strtol() converts to long.

> example,It accepts:
> 
> echo 1 > /proc/pid/clear_refs
> echo 12foo > /proc/pid/clear_refs
> 

http://userweb.kernel.org/~akpm/mmotm/broken-out/pagemap-clear_refs-modify-to-specify-anon-or-mapped-vma-clearing.patch
changes that, so you'll need to rebase on mmotm.
