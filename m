Return-Path: <linux-kernel-owner+w=401wt.eu-S1760058AbZCCAWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760058AbZCCAWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758764AbZCCAVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:21:43 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35822 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758235AbZCCAVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:21:42 -0500
Date: Tue, 3 Mar 2009 09:20:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 0/4] cgroups: show correct file mode
Message-Id: <20090303092021.93e69b96.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830903021615j6e1380e2l1544b67b187c1f5e@mail.gmail.com>
References: <49AB40BF.4030706@cn.fujitsu.com>
	<6599ad830903021019p3b29c173oc7772af6679d90e0@mail.gmail.com>
	<20090303090950.60cea53a.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830903021615j6e1380e2l1544b67b187c1f5e@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 16:15:51 -0800
Paul Menage <menage@google.com> wrote:

> On Mon, Mar 2, 2009 at 4:09 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> >        int mode;
> >        if (cft->mode)
> >                mode = cft->mode;
> >        else if (cft->write_xxx || .....)
> >                mode = 0644;
> >        else
> >                mode = 0444;
> 
> Almost:
> 
> int mode;
> if (cft->mode) {
>   mode = cft->mode;
> } else {
>   if (cft->write_xxx || ....)
>     mode |= 0600;
>   if (cft->read_xxx || ...)
>     mode |= 0444;
> }
> 
Oh, I see. But int mode=0, at first ;)
I have no objections but please forgive subsys to set mode=0644 explicitly.

Thanks,
-Kame

