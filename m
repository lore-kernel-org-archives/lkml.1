Return-Path: <linux-kernel-owner+w=401wt.eu-S1762027AbXGVI3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762027AbXGVI3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 04:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468AbXGVI33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 04:29:29 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:49186 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754554AbXGVI30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 04:29:26 -0400
Message-ID: <385092954.31836@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sun, 22 Jul 2007 16:29:23 +0800
From: Fengguang Wu <fengguang.wu@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Jones <davej@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tim Pepper <lnxninja@us.ibm.com>,
       Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
Message-ID: <20070722082923.GA7790@mail.ustc.edu.cn>
Mail-Followup-To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Dave Jones <davej@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>
References: <20070721210005.000228000@chello.nl> <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com> <385091802.23116@ustc.edu.cn> <1185092677.20032.197.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185092677.20032.197.camel@twins>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 10:24:37AM +0200, Peter Zijlstra wrote:
> On Sun, 2007-07-22 at 16:10 +0800, Fengguang Wu wrote:
> 
> > - It will avoid large-file-reads-thrashing-my-desktop problem,
> >   so most desktop users should like it. But sure there will be counter
> >   cases when a user want to keep the data cached.
> > - File servers may hurt from it. Imagine a mp3/png file server. The
> >   files are large enough to trigger drop-behind, but small (and hot)
> >   enough to be cached. Also when a new fedora DVD iso is released, it
> >   may be cached for some days. These are only the obvious cases.
> > 
> > So I opt for it being made tunable, safe, and turned off by default.
> 
> I'm still not convinced (Rik wasn't either last time around). When these
> files really are hot, they will be kept in memory due to them becoming
> Active.
> 
> Also, by scaling up the max readahead size it takes a larger file before
> it starts dropping. If say this server has 4G of memory (not much at all
> for a server) resulting in a 1M readahead window, the file needs to be >
> ~2M before it starts drop behind.

[snip]

> But I guess it takes someone to try this IRL before we can settle this
> debate :-/

Yeah, some real workload numbers would help.

