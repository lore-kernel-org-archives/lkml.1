Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbZLDA3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbZLDA3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 19:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbZLDA3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 19:29:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbZLDA3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 19:29:37 -0500
Message-ID: <4B1857ED.30304@redhat.com>
Date: Thu, 03 Dec 2009 19:29:33 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Larry Woodman <lwoodman@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC] high system time & lock contention running large mixed
 workload
References: <20091125133752.2683c3e4@bree.surriel.com>	 <1259618429.2345.3.camel@dhcp-100-19-198.bos.redhat.com>	 <20091201102645.5C0A.A69D9226@jp.fujitsu.com>	 <1259685662.2345.11.camel@dhcp-100-19-198.bos.redhat.com>	 <4B15CEE0.2030503@redhat.com> <1259878496.2345.57.camel@dhcp-100-19-198.bos.redhat.com>
In-Reply-To: <1259878496.2345.57.camel@dhcp-100-19-198.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2009 05:14 PM, Larry Woodman wrote:

> The attached patch addresses this issue by changing page_check_address()
> to return -1 if the spin_trylock() fails and page_referenced_one() to
> return 1 in that path so the page gets moved back to the active list.

Your patch forgot to add the code to vmscan.c to actually move
the page back to the active list.

Also, please use an enum for the page_referenced return
values, so the code in vmscan.c can use symbolic names.

enum page_reference {
	NOT_REFERENCED,
	REFERENCED,
	LOCK_CONTENDED,
};

-- 
All rights reversed.
