Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbYAOW7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbYAOW7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYAOW7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:59:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbYAOW7g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:59:36 -0500
Date: Tue, 15 Jan 2008 17:59:25 -0500
From: Rik van Riel <riel@redhat.com>
To: "Daniel =?UTF-8?B?U3DDpW5n?=" <daniel.spang@gmail.com>
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, "Marcelo Tosatti" <marcelo@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 4/5] memory_pressure_notify() caller
Message-ID: <20080115175925.215471e1@bree.surriel.com>
In-Reply-To: <cfd9edbf0801151455j48669850s7ea4fe589dbb9710@mail.gmail.com>
References: <20080115092828.116F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080115100124.117B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<cfd9edbf0801151455j48669850s7ea4fe589dbb9710@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 23:55:17 +0100
"Daniel Spång" <daniel.spang@gmail.com> wrote:

> The notification fires after only ~100 MB allocated, i.e., when page
> reclaim is beginning to nag from page cache. Isn't this a bit early?
> Repeating the test with swap enabled results in a notification after
> ~600 MB allocated, which is more reasonable and just before the system
> starts to swap.

Your issue may have more to do with the fact that the
highmem zone is 128MB in size and some balancing issues
between __alloc_pages and try_to_free_pages.

-- 
All rights reversed.
