Return-Path: <linux-kernel-owner+w=401wt.eu-S2992550AbXDDC5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992550AbXDDC5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992549AbXDDC5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:57:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992550AbXDDC5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:57:08 -0400
Message-ID: <461313FB.2030403@redhat.com>
Date: Tue, 03 Apr 2007 22:56:59 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Marko Macek <Marko.Macek@gmx.net>
CC: Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com> <4613131A.2060206@gmx.net>
In-Reply-To: <4613131A.2060206@gmx.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marko Macek wrote:
> Ulrich Drepper wrote:
>> A solution for this problem is a madvise() operation with the following
>> property:
>>
>>   - the content of the address range can be discarded
>>
>>   - if an access to a page in the range happens in the future it must
>>     succeed.  The old page content can be provided or a new, empty page
>>     can be provided
> 
> Doesn't this conflict with disabling overcommit?

Not really.  The threshold below which glibc does not give memory
back to the kernel at all is dynamic already.  It is entirely
possible to make an application that frees tens of thousands of
3000 byte chunks, in a pattern that makes it impossible for glibc
to return any memory to the kernel.

If you want to run without overcommit, don't run too close to the
wire :)

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
