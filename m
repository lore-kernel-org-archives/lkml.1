Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbZLJM7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbZLJM7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 07:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbZLJM7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 07:59:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbZLJM7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 07:59:41 -0500
Message-ID: <4B20EF88.7050402@redhat.com>
Date: Thu, 10 Dec 2009 07:54:32 -0500
From: Larry Woodman <lwoodman@redhat.com>
Reply-To: lwoodman@redhat.com
Organization: RedHat
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC][PATCH v2  4/8] Replace page_referenced() with wipe_page_reference()
References: <20091210154822.2550.A69D9226@jp.fujitsu.com> <20091210163123.255C.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091210163123.255C.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> @@ -578,7 +577,9 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>
> +		struct page_reference_context refctx = {
> +			.is_page_locked = 1,
>
>   *
> @@ -1289,7 +1291,6 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
>
> +		struct page_reference_context refctx = {
> +			.is_page_locked = 0,
> +		};
> +
>   
are these whole structs properly initialized on the kernel stack?

