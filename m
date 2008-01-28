Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYA1ENY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYA1ENY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 23:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYA1ENN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 23:13:13 -0500
Received: from mx2.netapp.com ([216.240.18.37]:26000 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbYA1ENM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 23:13:12 -0500
X-IronPort-AV: E=Sophos;i="4.25,257,1199692800"; 
   d="scan'208";a="146715059"
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Andi Kleen <ak@suse.de>
Cc: Steve French <smfrench@gmail.com>, swhiteho@redhat.com, sfrench@samba.org,
       vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <200801280358.14024.ak@suse.de>
References: <20080127317.043953000@suse.de>
	 <524f69650801271418s16f88928xc58dcbe9f5ede9e4@mail.gmail.com>
	 <1201475336.7346.37.camel@heimdal.trondhjem.org>
	 <200801280358.14024.ak@suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Sun, 27 Jan 2008 23:13:09 -0500
Message-Id: <1201493589.8132.7.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 28 Jan 2008 04:13:10.0644 (UTC) FILETIME=[17F25340:01C86164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-28 at 03:58 +0100, Andi Kleen wrote:
> The problem is that it's not a race in who gets to do its thing first, but a 
> parallel reader can actually see a corrupted value from the two independent 
> words on 32bit (e.g. during a 4GB). And this could actually completely corrupt 
> f_pos when it happens with two racing relative seeks or read/write()s
> 
> I would consider that a bug.

I disagree. The corruption occurs because this isn't a situation that is
allowed by either POSIX or SUSv2/v3. Exactly what spec are you referring
to here?

Trond
