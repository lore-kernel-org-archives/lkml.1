Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbZE2R0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbZE2R0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 13:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZE2R0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 13:26:32 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59681 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbZE2R0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 13:26:31 -0400
Subject: Re: [PATCH 18/38] C/R: core stuff
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, xemul@parallels.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090529060131.GA5504@x200.localdomain>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
	 <1242968132-1044-18-git-send-email-adobriyan@gmail.com>
	 <20090526131644.GA20920@hallyn.com>
	 <20090526193503.GB11909@x200.localdomain>
	 <4A1DA8FB.3000306@cs.columbia.edu> <20090527221753.GB8321@x200.localdomain>
	 <4A1DC270.8080807@cs.columbia.edu>
	 <20090528153322.GB18256@x200.localdomain>
	 <4A1F0E29.2040506@cs.columbia.edu> <20090529060131.GA5504@x200.localdomain>
Content-Type: text/plain
Date: Fri, 29 May 2009 10:26:27 -0700
Message-Id: <1243617988.14679.69.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 10:01 +0400, Alexey Dobriyan wrote:
>                 if (ctx->dump_live)
>                         down_read(&uts_sem);
>                 strncpy(i->sysname, (const char *)uts_ns->name.sysname, 64);
>                 strncpy(i->nodename, (const char *)uts_ns->name.nodename, 64);
>                 strncpy(i->release, (const char *)uts_ns->name.release, 64);
>                 strncpy(i->version, (const char *)uts_ns->name.version, 64);
>                 strncpy(i->machine, (const char *)uts_ns->name.machine, 64);
>                 strncpy(i->domainname, (const char *)uts_ns->name.domainname, 64);
>                 if (ctx->dump_live)
>                         up_read(&uts_sem);

Doesn't this turn a minor bug (like a task getting accidentally
unfrozen) into a oopsable bug?

I mean, doing this without a lock is nice and all, but it adds code to
make it selectable.  What's the purpose of avoiding the semaphore
anyway?  Performance?

-- Dave

