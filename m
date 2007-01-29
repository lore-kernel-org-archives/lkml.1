Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbXA2WeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbXA2WeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932941AbXA2WeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:34:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834AbXA2WeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:34:17 -0500
Message-ID: <45BE7584.8040808@redhat.com>
Date: Mon, 29 Jan 2007 17:30:28 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: =?UTF-8?B?UGF3ZcWCIFNpa29yYQ==?= <pluto@agmk.net>
CC: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Adrian Bunk <bunk@stusta.de>, linux-acpi@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: 2.6.20rc5 k8/acpi regression ( 2.6.17.13 works fine ).
References: <200701242346.44673.pluto@agmk.net> <20070124225238.GT17836@stusta.de> <200701242350.45276.lenb@kernel.org> <200701252311.46858.pluto@agmk.net>
In-Reply-To: <200701252311.46858.pluto@agmk.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paweł Sikora wrote:
> On Thursday 25 of January 2007 05:50:45 Len Brown wrote:
>   
>> On Wednesday 24 January 2007 17:52, Adrian Bunk wrote:
>>     
>>> On Wed, Jan 24, 2007 at 11:46:44PM +0100, Paweł Sikora wrote:
>>>       
>>>> for 2.6.20rc5 i get an acpi related oops during x86-64 boot:
>>>> http://minus.ds14.agh.edu.pl/~pluto/2.6.20rc5-acpi-oops.jpg
>>>> disabling the "amd-k8 cool'n'quiet" option in bios helps.
>>>> moreover, it works fine for 2.6.17.13, so it looks like
>>>> a recent regression. i can provide more details if you need.
>>>>         
>>> thanks for your report.
>>>
>>> Can you narrow down a bit when it started?
>>> Is 2.6.19 OK?
>>> Is 2.6.18 OK?
>>>       
>> Is the stack trace always the same?  It doesn't make much sense to me.
>>     
>
> with debug options enabled oops looks better:
> http://minus.ds14.agh.edu.pl/~pluto/2.6.20rc5-oops-01.jpg
>
>   

In __rmqueue() (mm/page_alloc.c line 619:

static struct page *__rmqueue(struct zone *zone, unsigned int order)
{
        struct free_area * area;
        unsigned int current_order;
        struct page *page;

        for (current_order = order; current_order < MAX_ORDER;
++current_order) {
                area = zone->free_area + current_order;
                if (list_empty(&area->free_list))
                        continue;

                page = list_entry(area->free_list.next, struct page, lru);
                list_del(&page->lru);   <=====================
                rmv_page_order(page);
                area->nr_free--;

page->lru is NULL



