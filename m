Return-Path: <linux-kernel-owner+w=401wt.eu-S1752398AbXCPA5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbXCPA5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 20:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbXCPA5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 20:57:15 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35251 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbXCPA5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 20:57:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Hansen <hansendc@us.ibm.com>, menage@google.com,
       containers@lists.osdl.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, xemul@sw.ru
Subject: Re: [RFC][PATCH 2/7] RSS controller core
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru>
	<20070306140036.4e85bd2f.akpm@linux-foundation.org>
	<45F3F581.9030503@sw.ru>
	<20070311045111.62d3e9f9.akpm@linux-foundation.org>
	<20070312010039.GC21861@MAIL.13thfloor.at>
	<1173724979.11945.103.camel@localhost.localdomain>
	<20070312224129.GC21258@MAIL.13thfloor.at>
	<20070312220439.677b4787.akpm@linux-foundation.org>
	<1173806793.6680.44.camel@localhost.localdomain>
	<20070313190931.1417c012@lxorguk.ukuu.org.uk>
Date: Thu, 15 Mar 2007 18:55:45 -0600
In-Reply-To: <20070313190931.1417c012@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Tue, 13 Mar 2007 19:09:31 +0000")
Message-ID: <m1mz2enh0u.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> stuff is happening by comparing page->count and page->_mapcount, but it
>> certainly wouldn't be conclusive.  But, does this kind of nonsense even
>> happen in practice?  
>
> "Is it useful for me as a bad guy to make it happen ?"

To create a DOS attack.

- Allocate some memory you know your victim will want in the future,
  (shared libraries and the like).
- Wait until your victim is using the memory you allocated.
- Terminate your memory resource group.
- Victim is pushed over memory limits by your exiting.
- Victim can no longer allocate memory
- Victim dies

It's not quite that easy unless your victim calls mlockall(MCL_FUTURE),
but the potential is clearly there.

Am I missing something?  Or is this fundamental to any first touch scenario?

I just know I have problems with first touch because it is darn hard to
reason about.

Eric
