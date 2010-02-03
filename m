Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab0BCX4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 18:56:49 -0500
Received: from science.horizon.com ([71.41.210.146]:20445 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932915Ab0BCX4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 18:56:47 -0500
Date: 3 Feb 2010 18:56:44 -0500
Message-ID: <20100203235644.3084.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: catalin.marinas@arm.com
Subject: Re: USB mass storage and ARM cache coherency
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Apart from that, flush_dcache_page() doesn't have any data flow
> information. Optimisations could be done on ARM if we know that the
> kernel only intends to read from a page (no flushing necessary with a
> non-aliasing D-cache).

Already done in flush_dcache_page().  If possible (uniprocessor), it just
flags the page as PG_dcache_dirty, and defers the actual flush operation
until it's mapped somewhere else (either a virtual alias or executable).

See Documentation/cachetlb.txt.  (Really, all PIO drivers should
be calling flush_dcache_page.)
