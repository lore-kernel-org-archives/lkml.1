Return-Path: <linux-kernel-owner+w=401wt.eu-S1760780AbXESMar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780AbXESMar (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 08:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbXESMaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 08:30:39 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:51910 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754136AbXESMaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 08:30:39 -0400
Message-ID: <379577826.15160@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 19 May 2007 20:30:31 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Jens Axboe <jens.axboe@oracle.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Steven Pratt <slpratt@austin.ibm.com>, Ram Pai <linuxram@us.ibm.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 1/9] readahead: introduce PG_readahead
Message-ID: <20070519123031.GA6095@mail.ustc.edu.cn>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	Jens Axboe <jens.axboe@oracle.com>, Oleg Nesterov <oleg@tv-sign.ru>,
	Steven Pratt <slpratt@austin.ibm.com>,
	Ram Pai <linuxram@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
References: <20070516224752.500812933@mail.ustc.edu.cn> <379355695.83536@ustc.edu.cn> <20070518232824.9917d794.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518232824.9917d794.akpm@linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 11:28:24PM -0700, Andrew Morton wrote:
> On Thu, 17 May 2007 06:47:53 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> 
> > Introduce a new page flag: PG_readahead.
> 
> Is there any way in which we can avoid adding a new page flag?
> 
> We have the advantage that if the kernel very occasionally gets the wrong
> result for PageReadahead(page), nothing particularly bad will happen, so we
> can do racy things.
> 
> >From a quick peek, it appears that PG_readahead is only ever set against
> non-uptodate pages.  If true we could perhaps exploit that: say,
> PageReadahead(page) == PG_referenced && !PG_uptodate?

PG_uptodate will flip to 1 before the reader touches the page :(

However, it may be possible to share the same bit with PG_reclaim or PG_booked.
Which one would be preferred?

