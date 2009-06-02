Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZFBUxC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZFBUxC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:53:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbZFBUwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:52:53 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35452 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZFBUwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:52:51 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Al Viro <viro@ZenIV.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>, Tejun Heo <tj@kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/23] vfs: Introduce infrastructure for revoking a file
References: <m1oct739xu.fsf@fess.ebiederm.org>
	<1243893048-17031-4-git-send-email-ebiederm@xmission.com>
	<20090602071411.GE31556@wotan.suse.de>
	<alpine.LFD.2.01.0906021005190.3351@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 02 Jun 2009 13:52:46 -0700
In-Reply-To: <alpine.LFD.2.01.0906021005190.3351@localhost.localdomain> (Linus Torvalds's message of "Tue\, 2 Jun 2009 10\:06\:00 -0700 \(PDT\)")
Message-ID: <m1y6sas6ht.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: torvalds@linux-foundation.org, ebiederm@aristanetworks.com, hch@infradead.org, akpm@linux-foundation.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk, npiggin@suse.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, 2 Jun 2009, Nick Piggin wrote:
>>
>> Why is it called hotplug? Does it have anything to do with hardware?
>> Because every concurrently changed software data structure in the
>> kernel can be "hot"-modified, right?
>> 
>> Wouldn't file_revoke_lock be more appropriate?
>
> I agree, "hotplug" just sounds crazy. It's "open" and "revoke", not 
> "plug" and "unplug".

I guess this shows my bias in triggering this code path from pci
hotunplug.  Instead of with some system call.

I'm not married to the name.  I wanted file_lock but that is already
used, and I did call the method revoke.

The only place where hotplug gives a useful hint is that it makes it
clear we really are disconnecting the file descriptor from what lies
below it.  We can't do some weird thing like keep the underlying object.
Because the underlying object is gone.

Eric
