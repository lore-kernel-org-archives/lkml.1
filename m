Return-Path: <linux-kernel-owner+w=401wt.eu-S1759734AbZCCALg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759734AbZCCALg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbZCCALN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:11:13 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55351 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbZCCALM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:11:12 -0500
Date: Tue, 3 Mar 2009 09:09:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 0/4] cgroups: show correct file mode
Message-Id: <20090303090950.60cea53a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830903021019p3b29c173oc7772af6679d90e0@mail.gmail.com>
References: <49AB40BF.4030706@cn.fujitsu.com>
	<6599ad830903021019p3b29c173oc7772af6679d90e0@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 10:19:15 -0800
Paul Menage <menage@google.com> wrote:

> On Sun, Mar 1, 2009 at 6:13 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> > Now a cgroup subsystem can set default file mode of its control files,
> > so here is a patchset to correct file mode of each subsystem's files.
> 
> I really think that we should be defaulting this based on whether the
> control file has read or write handlers.
> 
> Sure, there are special cases like "tasks" that we'd need to set a
> manual value for, but most of these patches would be unnecessary.
> 
like this ?
  
	int mode;
	if (cft->mode)
		mode = cft->mode;
	else if (cft->write_xxx || .....)
		mode = 0644;
	else
		mode = 0444;
Thanks,
-Kame

