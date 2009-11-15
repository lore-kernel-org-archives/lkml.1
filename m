Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbZKOK5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbZKOK5M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 05:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbZKOK5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 05:57:11 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60591 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZKOK5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:57:10 -0500
Date: Sun, 15 Nov 2009 19:57:11 +0900 (JST)
Message-Id: <20091115.195711.77834168.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
       fweisbec@gmail.com
Subject: Re: [PATCH v3] perf tools: New function to parse string
 representing size in bytes
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091115102859.GA24931@elte.hu>
References: <20091115.185220.212229853.mitake@dcl.info.waseda.ac.jp>
	<1258280343-4359-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<20091115102859.GA24931@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3] perf tools: New function to parse string representing size in bytes
Date: Sun, 15 Nov 2009 11:28:59 +0100

> 
> * Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:
> 
> > + * bytesexp2int()
> 
> i suspect this could be named 'bytestring2ll' ? Is 'bytesexp' an 
> existing naming in other libraries?

Sorry, I've forgot to rename.
And bytesexp may not exist in other libraries.
I couldn't create nice name for the notion number + unit in byes.

> 
> > + * Parse (\d+)(b|B|kb|KB|mb|MB|gb|GB|tb|TB) (e.g. "256MB")
> > + * and return its numeric value
> > + */
> > +long long int bytesexp2int(const char *str)
> 
> we have type shortcuts for 'long long': s64.
Thanks, I use s64. This is easy to type.

> 
> > +{
> > +	unsigned int i;
> > +	long long int length = -1, unit = 1;
> 
> s64 too i suspect.
> 
> > +tera:
> > +			unit = (long long int)K * K * K * K;
> 
> Note, you can probably avoid this type cast if you define the 'K' 
> literal as 1024LL or so.
I've forgot this notation, thanks.

> 
> > +	length = atoll(str) * unit;
> 
> we might want to take a naming clue here and name this new function as 
> atoll_exp(), to signal that it works like atoll, just with an extension 
> for KB/MB/GB/etc. expressions?

Hm, how about "atoll_byteunit()"?
This may have no ambiguity.
