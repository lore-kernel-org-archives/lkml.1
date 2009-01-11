Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbZAKVOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbZAKVOu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbZAKVOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:14:38 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:45647 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZAKVOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:14:37 -0500
Date: Mon, 12 Jan 2009 00:14:55 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, klausman@schwarzvogel.de
Subject: Re: WARNING in vmap_page_range on alpha since 2.6.28
Message-ID: <20090111211455.GB1641@jurassic.park.msu.ru>
References: <20090111141855.GA7416@eric.schwarzvogel.de> <20090111183600.GA2728@ds20.borg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111183600.GA2728@ds20.borg.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 06:36:00PM +0000, Thorsten Kranzkowski wrote:
> I see similar traces:
> 
> ------------[ cut here ]------------
> WARNING: at /export/data/scm/linux-2.6/mm/vmalloc.c:104 vmap_page_range+0x1c4/0x264()

The problem is that alpha allocates some VMALLOC space very early
on boot, but the new VM allocator doesn't know about this.

I've posted a fix few days ago:
http://lkml.org/lkml/2009/1/7/574

Ivan.
