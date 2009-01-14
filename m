Return-Path: <linux-kernel-owner+w=401wt.eu-S1760463AbZANIiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463AbZANIiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbZANIik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:38:40 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:49709 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbZANIij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:38:39 -0500
Date: Wed, 14 Jan 2009 14:08:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: fix return value of mem_cgroup_hierarchy_write()
Message-ID: <20090114083835.GL27129@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <496D9E0C.4060806@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <496D9E0C.4060806@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Li Zefan <lizf@cn.fujitsu.com> [2009-01-14 16:10:52]:

> When there are sub-dirs, writing to memory.use_hierarchy returns -EBUSY,
> this doesn't seem to fit the meaning of EBUSY, and is inconsistent with
> memory.swappiness, which returns -EINVAL in this case.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

The patch does much more than the changelog says. The reason for EBUSY
is that the group is in use due to children or existing references and
tasks. I think EBUSY is the correct error code to return.

-- 
	Balbir
