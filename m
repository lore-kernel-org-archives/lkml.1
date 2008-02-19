Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbYBSTD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbYBSTD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYBSTDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:03:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbYBSTDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:03:14 -0500
Date: Tue, 19 Feb 2008 14:02:22 -0500
From: Rik van Riel <riel@redhat.com>
To: Paul Jackson <pj@sgi.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, marcelo@kvack.org, daniel.spang@gmail.com,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-fsdevel@vger.kernel.org, pavel@ucw.cz, a1426z@gawab.com,
       jonathan@jonmasters.org, zlynx@acm.org
Subject: Re: [PATCH 0/8][for -mm] mem_notify v6
Message-ID: <20080219140222.4cee07ab@cuia.boston.redhat.com>
In-Reply-To: <20080219090008.bb6cbe2f.pj@sgi.com>
References: <2f11576a0802090719i3c08a41aj38504e854edbfeac@mail.gmail.com>
	<20080217084906.e1990b11.pj@sgi.com>
	<20080219145108.7E96.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080219090008.bb6cbe2f.pj@sgi.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 09:00:08 -0600
Paul Jackson <pj@sgi.com> wrote:

> Depending on what we're trying to do:
>  1) warn applications of swap coming soon (your case),
>  2) show how close we are to swapping,
>  3) show how much swap has happened already,
>  4) kill instantly if try to swap (my hpc case),
>  5) measure file i/o caused by memory pressure, or
>  6) perhaps other goals,
> we will need to hook different places in the kernel.
> 
> It may well be that your hooks for embedded are simply in different
> places than my hooks for HPC.  If so, that's fine.

Don't forget the "hooks for desktop" :)

Basically in all situations, the kernel needs to warn at the same point
in time: when the system is about to run out of RAM for anonymous pages.

In the desktop case, that leads to swapping (and programs can free memory).

In the embedded case, it leads to OOM (and a management program can kill or
restart something else, or a program can restart itself).

In the HPC case, it leads to swapping (and a management program can kill or
restart something else).

I do not see the kernel side being different between these situations, only
userspace reacts differently in the different scenarios.

Am I overlooking something?

-- 
All Rights Reversed
