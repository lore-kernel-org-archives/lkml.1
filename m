Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbZKQVJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbZKQVJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 16:09:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZKQVJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 16:09:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbZKQVJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 16:09:06 -0500
Message-ID: <4B0310CD.6050303@redhat.com>
Date: Tue, 17 Nov 2009 16:08:29 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Eyal Lotem <eyal.lotem@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Using "page credits" as a solution for common thrashing
 	scenarios
References: <b64f365b0911171252q42a0c102jddb2cd29af64a7a7@mail.gmail.com>
In-Reply-To: <b64f365b0911171252q42a0c102jddb2cd29af64a7a7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2009 03:52 PM, Eyal Lotem wrote:
> Highly simplified example of suggested solution (numbers are made up):
>
> NOTE: The example does not include shared library memory use and various
> other details (I do believe this solution handles those elegantly), to
> avoid clutter.
>
>    
The real problematic details are in the data structures.

How to organize the pages in-kernel?

How does the kernel find the pages with the lowest
score?  In the memory zone where memory needs
to be freed...

How can the kernel efficiently change the score of
tens of thousands (or even millions) of pages at once,
moving them to the right LRU list cheaply?

Making page replacement scale to systems with
hundreds of gigabytes of memory is a necessity, as
is evicting the right kind of page (filesystem cache
vs process page, etc).

Within those constraints, it becomes very hard to
implement a solution along your ideas.
