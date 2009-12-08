Return-Path: <linux-kernel-owner+w=401wt.eu-S932522AbZLHQQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbZLHQQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 11:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932501AbZLHQQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 11:16:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491AbZLHQQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 11:16:57 -0500
Message-ID: <4B1E7B47.1000707@redhat.com>
Date: Tue, 08 Dec 2009 11:13:59 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Elladan <elladan@eskimo.com>, Peter Zijlstra <peterz@infradead.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>, epasch@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: Increased Buffers due to patch 56e49d (vmscan: evict use-once
 pages first), but why exactly?
References: <4B1D12E7.4070701@linux.vnet.ibm.com> <4B1D46C0.4040503@redhat.com> <20091208093533.B57B.A69D9226@jp.fujitsu.com> <4B1E76C9.50901@linux.vnet.ibm.com>
In-Reply-To: <4B1E76C9.50901@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2009 10:54 AM, Christian Ehrhardt wrote:

> btw thanks for the explanation Rik, the file/blockdev association was
> exactly what I was missing in my thoughts.
> While my question was more intended to ask where in code these
> differentiation is made I'm perfectly fine with having it just working
> knowing that file/blockdev association is the key.

Actually, the file/blockdev association is just a coincidence,
due to the way your benchmark works.

The key is "page touched once" vs "page touched multiple times".

In eg. a database workload, I would expect much more file data
to be on the active list.  Specifically the file data corresponding
to the database indexes.

-- 
All rights reversed.
