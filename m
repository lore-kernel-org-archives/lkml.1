Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107AbYA0XJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbYA0XJR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 18:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYA0XJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 18:09:01 -0500
Received: from mx2.netapp.com ([216.240.18.37]:18855 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811AbYA0XI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 18:08:59 -0500
X-IronPort-AV: E=Sophos;i="4.25,257,1199692800"; 
   d="scan'208";a="146673496"
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Steve French <smfrench@gmail.com>
Cc: Andi Kleen <ak@suse.de>, swhiteho@redhat.com, sfrench@samba.org,
       vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <524f69650801271418s16f88928xc58dcbe9f5ede9e4@mail.gmail.com>
References: <20080127317.043953000@suse.de>
	 <20080127021714.A223614D2E@wotan.suse.de>
	 <524f69650801270857i6610e736q4189dc6af9b22360@mail.gmail.com>
	 <1201456562.7346.13.camel@heimdal.trondhjem.org>
	 <524f69650801271418s16f88928xc58dcbe9f5ede9e4@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Sun, 27 Jan 2008 18:08:56 -0500
Message-Id: <1201475336.7346.37.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 27 Jan 2008 23:08:58.0356 (UTC) FILETIME=[98BC3340:01C86139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-27 at 16:18 -0600, Steve French wrote:
> If two seeks overlap, can't you end up with an f_pos value that is
> different than what either thread seeked to? or if you have a seek and
> a read overlap can't you end up with the read occurring in the midst
> of an update of f_pos (which takes more than one instruction on
> various architectures), e.g. reading an f_pos, which has only the
> lower half of a 64 bit field updated?   I agree that you shouldn't
> have seeks racing in parallel but I think it is preferable to get
> either the updated f_pos or the earlier f_pos not something 1/2
> updated.

Why? The threads are doing something inherently liable to corrupt data
anyway. If they can race over the seek, why wouldn't they race over the
read or write too?
The race in lseek() should probably be the least of your worries in this
case.

Trond
