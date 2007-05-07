Return-Path: <linux-kernel-owner+w=401wt.eu-S933771AbXEGNJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771AbXEGNJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 09:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933780AbXEGNJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 09:09:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933771AbXEGNJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 09:09:11 -0400
Message-ID: <463F24DB.5040406@redhat.com>
Date: Mon, 07 May 2007 06:08:43 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
References: <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070503212955.b1b6443c.akpm@linux-foundation.org> <20070504060731.GJ32602149@melbourne.sgi.com> <20070503232815.2f62a75e.akpm@linux-foundation.org> <20070504065626.GW355@devserv.devel.redhat.com>
In-Reply-To: <20070504065626.GW355@devserv.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub Jelinek wrote:
> is what glibc does ATM.  Seems we violate the case where len == 0, as
> EINVAL in that case is "shall fail".  But reading the standard to imply
> negative len is ok is too much guessing, there is no word what it means
> when len is negative and
> "required storage for regular file data starting at offset and continuing for len bytes"
> doesn't make sense for negative size.  

This wording has already been cleaned up.  The current draft for the 
next revision reads:


[EINVAL] The len argument is less than or equal to zero, or the offset
  argument is less than zero, or the underlying file system does not
  support this operation.


I still don't like it since len==0 shouldn't create an error (it's 
inconsistent) but len<0 is already outlawed.

-- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
