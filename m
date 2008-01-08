Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYAHLQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYAHLQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 06:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYAHLQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 06:16:01 -0500
Received: from mx2-2.mail.ru ([194.67.23.122]:10662 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750857AbYAHLQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 06:16:00 -0500
Date: Tue, 8 Jan 2008 14:15:53 +0300
From: Evgeniy Dushistov <dushistov@mail.ru>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.24-rc3
Message-ID: <20080108111549.GA30832@rain>
Mail-Followup-To: James Bottomley <James.Bottomley@HansenPartnership.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-scsi <linux-scsi@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1195989865.3427.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1195989865.3427.16.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2007 at 01:24:25PM +0200, James Bottomley wrote:
> This is a bit of a rash of bug fixes.  The qla1280 is actually a bug fix
> (in spite of the title---it's actually correcting an existing problem
> with the qla1280 implementation of accessors that broke the current
> driver).
> 

Recently I build last Linus's git tree, and got:
‘req_cnt’ is used uninitialized in this function,
and see bellow
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> 
> The short changelog is:
...
> Jes Sorensen (1):
>       qla1280: convert to use the data buffer accessors
> 
...
>  scsi/qla1280.c         |  387 +++++++++++++++++++++----------------------------
...
>  	/* Calculate number of entries and segments required. */
> -	req_cnt = 1;
> 

Initilization of req_cnt was removed, but in this function
there are places like 
req_cnt += (seg_cnt - 4) / 7;
or
req_cnt++;
This is should be so?

-- 
/Evgeniy

