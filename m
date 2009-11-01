Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZKAOp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZKAOp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 09:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbZKAOpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 09:45:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbZKAOpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 09:45:24 -0500
Message-ID: <4AED9EB4.5080601@redhat.com>
Date: Sun, 01 Nov 2009 09:44:04 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       stable@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 2/3] page allocator: Do not allow interrupts to use ALLOC_HARDER
References: <1256650833-15516-1-git-send-email-mel@csn.ul.ie> <1256650833-15516-3-git-send-email-mel@csn.ul.ie> <20091027130924.fa903f5a.akpm@linux-foundation.org> <alpine.DEB.2.00.0910271411530.9183@chino.kir.corp.google.com> <20091031184054.GB1475@ucw.cz> <alpine.DEB.2.00.0910311248490.13829@chino.kir.corp.google.com> <20091031201158.GB29536@elf.ucw.cz> <alpine.DEB.2.00.0910311413160.25524@chino.kir.corp.google.com> <20091031222905.GA32720@elf.ucw.cz> <4AECC04B.9060808@redhat.com> <20091101073527.GB32720@elf.ucw.cz>
In-Reply-To: <20091101073527.GB32720@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2009 02:35 AM, Pavel Machek wrote:
>>> I believe it would be better to simply remove it.
>>
>> You are against trying to give the realtime tasks a best effort
>> advantage at memory allocation?
>
> Yes. Those memory reserves were for kernel, GPF_ATOMIC and stuff. Now
> realtime tasks are allowed to eat into them. That feels wrong.
>
> "realtime" tasks are not automatically "more important".
>
>> Realtime apps often *have* to allocate memory on the kernel side,
>> because they use network system calls, etc...
>
> So what? As soon as they do that, they lose any guarantees, anyway.

They might lose the absolute guarantee, but that's no reason
not to give it our best effort!

-- 
All rights reversed.
