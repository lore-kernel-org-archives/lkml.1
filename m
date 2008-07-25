Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYGYGF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYGYGF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 02:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbYGYGFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 02:05:50 -0400
Received: from smtp-out.google.com ([216.239.33.17]:33437 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYGYGFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 02:05:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=hkNt/rd3R/MWbU8QiqDnRq5IibyMDcr58uiu6Kqe2PbhgMEOyi2cgcDNTXRc+Ut3+
	v4Dp/H3KQXSEG+SjjVGTg==
Message-ID: <6599ad830807242305w2895905dgcd91fe3a430806dc@mail.gmail.com>
Date: Fri, 25 Jul 2008 02:05:43 -0400
From: "Paul Menage" <menage@google.com>
To: "Hirofumi Nakagawa" <hnakagawa@miraclelinux.com>
Subject: Re: [RFC][PATCH][0/3] introduce rlimit cgroup
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48885A7F.80106@miraclelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <488722DF.9080003@miraclelinux.com>
	 <20080724150557.8697.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <48885A7F.80106@miraclelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> To set rlimit from other processes is my original intention.
> For I do not see a way to do it, please let me know if there were any
> exists.

No, there's no way to do that currently. I'm not sure if it's
generally safe to update the rlimit for another process.

If we're trying to use rlimits in a cgroup context then some rlimits
(e.g. max nice priority) ought to apply as additional caps on the
processes in the cgroup (e.g. if you set a max nice priority of 1 on a
cgroup, that ought to override any per-process settings) whereas
others (e.g. locked memory, open files, num processes) ought to apply
as an aggregate limit on the cgroup (so the sum of all open files
across the cgroup shouldn't be able to exceed the cgroup's "open
files" limit). E.g. see Balbir's memrlimit control groups patches that
are currently in -mm.

What concrete problem are you trying to solve here?

Paul
