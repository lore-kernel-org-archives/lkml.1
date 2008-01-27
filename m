Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbYA0Sqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbYA0Sqd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 13:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758128AbYA0SqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 13:46:00 -0500
Received: from mx1.netapp.com ([216.240.18.38]:12880 "EHLO mx1.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066AbYA0Spv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:45:51 -0500
X-Greylist: delayed 1832 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 13:45:51 EST
X-IronPort-AV: E=Sophos;i="4.25,257,1199692800"; 
   d="scan'208";a="218560066"
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Steve French <smfrench@gmail.com>
Cc: Andi Kleen <ak@suse.de>, swhiteho@redhat.com, sfrench@samba.org,
       vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <524f69650801270857i6610e736q4189dc6af9b22360@mail.gmail.com>
References: <20080127317.043953000@suse.de>
	 <20080127021714.A223614D2E@wotan.suse.de>
	 <524f69650801270857i6610e736q4189dc6af9b22360@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Sun, 27 Jan 2008 12:56:02 -0500
Message-Id: <1201456562.7346.13.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 27 Jan 2008 17:56:04.0246 (UTC) FILETIME=[E27E5B60:01C8610D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-27 at 10:57 -0600, Steve French wrote:
> Don't you need to a spinlock/spinunlock(i_lock) or something similar
> (there isn't a spinlock in the file struct unfortunately) around the
> reads and writes from f_pos in fs/read_write.c in remote_llseek with
> your patch since the reads/writes from that field are not necessarily
> atomic and threads could be racing in seek on the same file struct?

Where does is state in POSIX or SUS that we need to cater to that kind
of application?
In any case, the current behaviour of f_pos if two threads are sharing
the file struct is undefined no matter whether you spinlock or not,
since there is no special locking around sys_read() or sys_write().

Trond
