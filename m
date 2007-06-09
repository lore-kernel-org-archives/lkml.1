Return-Path: <linux-kernel-owner+w=401wt.eu-S968793AbXFICB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968793AbXFICB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 22:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967582AbXFICBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 22:01:46 -0400
Received: from wine.ocn.ne.jp ([220.111.47.146]:58143 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967552AbXFICBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 22:01:45 -0400
To: david@lang.hm
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,pathname matching
From: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>
References: <200706042303.28785.agruen@suse.de>
	<1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil>
	<200706090003.57722.agruen@suse.de>
	<20070609001703.GA17644@kroah.com>
	<Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm>
Message-Id: <200706091101.JAB31303.PTNNSGtM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Sat, 9 Jun 2007 11:01:41 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

David Lang wrote:
> as I understand it SELinux puts one label on each file, so if you have 
> three files accessed by two programs such that
> program A accesses files X Y
> program B accesses files Y Z
> 
> then files X Y and Z all need separate labels with the policy stateing 
> that program A need to access labels X, Y and program B needs to access 
> files Y Z
> 
> extended out this can come close to giving each file it's own label. AA 
> essentially does this and calls the label the path and computes it at 
> runtime instead of storing it somewhere.

I tried to give each file it's own label, but I couldn't do it.
http://sourceforge.jp/projects/tomoyo/document/nsf2003-en.pdf
There are many elements that forms too strong barrier between pathname and labels,
such as bind-mounts, hard links, newly created files, renamed files, temporary files and so on.
So I gave up giving each file a label that can be used as an identifier,
and took an approach to forbid unneeded mount operations, unneeded link operations,
unneeded renaming operations to keep the pathname represent it's own identifier as much as possible.

Thanks.
