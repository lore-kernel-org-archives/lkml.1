Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbYIQS3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbYIQS3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbYIQS2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:28:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355AbYIQS2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:28:54 -0400
Date: Wed, 17 Sep 2008 14:28:05 -0400
From: Rik van Riel <riel@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Populating multiple ptes at fault time
Message-ID: <20080917142805.41e2b07e@bree.surriel.com>
In-Reply-To: <48D142B2.3040607@goop.org>
References: <48D142B2.3040607@goop.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 10:47:30 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Minor faults are easier; if the page already exists in memory, we should
> just create mappings to it.  If neighbouring pages are also already
> present, then we can can cheaply create mappings for them too.

This is especially true for mmaped files, where we do not have to
allocate anything to create the mapping.

Populating multiple PTEs at a time is questionable for anonymous
memory, where we'd have to allocate extra pages.

-- 
All rights reversed.
