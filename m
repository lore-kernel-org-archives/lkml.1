Return-Path: <linux-kernel-owner+w=401wt.eu-S1754999AbYAWOrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbYAWOrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 09:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYAWOrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 09:47:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbYAWOrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 09:47:39 -0500
Date: Wed, 23 Jan 2008 14:47:17 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [dm-devel] [PATCH 0/2] dm-band: The I/O bandwidth controller: Overview
Message-ID: <20080123144717.GS8075@agk.fab.redhat.com>
Mail-Followup-To: Ryo Tsuruta <ryov@valinux.co.jp>,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com,
	containers@lists.linux-foundation.org,
	virtualization@lists.linux-foundation.org,
	xen-devel@lists.xensource.com
References: <20080123.215350.193721890.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123.215350.193721890.ryov@valinux.co.jp>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 09:53:50PM +0900, Ryo Tsuruta wrote:
> Dm-band gives bandwidth to each job according to its weight, 
> which each job can set its own value to.
> At this time, a job is a group of processes with the same pid or pgrp or uid.

It seems to rely on 'current' to classify bios and doesn't do it until the map
function is called, possibly in a different process context, so it won't
always identify the original source of the I/O correctly: people need to take
this into account when designing their group configuration and so this should
be mentioned in the documentation.

I've uploaded it here while we consider ways we might refine the architecture and
interfaces etc.:

  http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-add-band-target.patch

Alasdair
-- 
agk@redhat.com
