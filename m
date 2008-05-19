Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbYESBbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbYESBbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 21:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYESBbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 21:31:34 -0400
Received: from saeurebad.de ([85.214.36.134]:53168 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbYESBbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 21:31:33 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>
Subject: Re: bootmem: Double freeing a PFN on nodes spanning other nodes
References: <87skwhyj8g.fsf@saeurebad.de>
	<20080519093525.4867bfb4.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 19 May 2008 03:31:10 +0200
In-Reply-To: <20080519093525.4867bfb4.kamezawa.hiroyu@jp.fujitsu.com>
	(KAMEZAWA Hiroyuki's message of "Mon, 19 May 2008 09:35:25 +0900")
Message-ID: <87d4njulk1.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> On Sat, 17 May 2008 00:30:55 +0200
> Johannes Weiner <hannes@saeurebad.de> wrote:
>
>> Hi,
>> 
>> When memory nodes overlap each other, the bootmem allocator is not aware
>> of this and might pass the same page twice to __free_pages_bootmem().
>> 
>
> 1. init_bootmem_node() is called against a node, [start, end). After this,
>    all pages are 'allocated'.
> 2. free_bootmem_node() is called against available memory in a node.
> 3. bootmem allocator is ready.
>
> memory overlap seems not to be trouble while an arch's code calls
> free_bootmem_node() correctly.

Ah, I totally overlooked that one.  Thank you very much!

	Hannes
