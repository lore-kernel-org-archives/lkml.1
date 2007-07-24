Return-Path: <linux-kernel-owner+w=401wt.eu-S1751154AbXGXEAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154AbXGXEAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 00:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbXGXD7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 23:59:55 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:60079 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755282AbXGXD7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 23:59:55 -0400
Message-ID: <385249561.11284@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 24 Jul 2007 11:48:01 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/10] readahead: combine file_ra_state.prev_index/prev_offset into prev_pos
Message-ID: <20070724034801.GA7310@mail.ustc.edu.cn>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
References: <20070724020009.677809022@mail.ustc.edu.cn> <385243122.57859@ustc.edu.cn> <20070723205241.c50624ed.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723205241.c50624ed.akpm@linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 08:52:41PM -0700, Andrew Morton wrote:
> On Tue, 24 Jul 2007 10:00:12 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> 
> > -	ra->prev_index = page->index;
> > +	ra->prev_pos = page->index << PAGE_CACHE_SHIFT;
> 
> bug!  The rhs will get truncated befire it gets assigned to
> the lhs.  Need to cast page->index to loff_t.
> 
> I'll fix this one up.  Please review the other patches for this?

Thank you. Be sure to update *all* the lines:
        ra->prev_pos = page->index << PAGE_CACHE_SHIFT

Other places should have been taken care of.

