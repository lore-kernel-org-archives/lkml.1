Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbYA1Cny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbYA1Cny (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 21:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbYA1Cnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 21:43:43 -0500
Received: from mx1.suse.de ([195.135.220.2]:41272 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbYA1Cnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 21:43:42 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Steve French" <smfrench@gmail.com>
Subject: Re: [PATCH] [8/18] BKL-removal: Remove BKL from remote_llseek
Date: Mon, 28 Jan 2008 03:43:27 +0100
User-Agent: KMail/1.9.6
Cc: Trond.Myklebust@netapp.com, swhiteho@redhat.com, sfrench@samba.org,
       vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
References: <20080127317.043953000@suse.de> <20080127021714.A223614D2E@wotan.suse.de> <524f69650801270857i6610e736q4189dc6af9b22360@mail.gmail.com>
In-Reply-To: <524f69650801270857i6610e736q4189dc6af9b22360@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801280343.27611.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008 17:57:14 Steve French wrote:
> Don't you need to a spinlock/spinunlock(i_lock) or something similar
> (there isn't a spinlock in the file struct unfortunately) around the
> reads and writes from f_pos in fs/read_write.c in remote_llseek with
> your patch since the reads/writes from that field are not necessarily
> atomic and threads could be racing in seek on the same file struct?

Funny that you mention it. I actually noticed this too while working on this, 
but noticed that it is wrong everywhere (as in even plain sys_write/read gets 
it wrong). So I decided to not address it because it is already
broken. 

I did actually send email to a few people about this, but no answer
yet.

I agree it's probably all broken on 32bit platforms, but I'm not
sure how to best address this. When it is comprehensively addressed remote_llseek 
can use that new method too.

-Andi

