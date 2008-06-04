Return-Path: <linux-kernel-owner+w=401wt.eu-S1759154AbYFDJU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759154AbYFDJU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 05:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYFDJUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 05:20:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57852 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbYFDJUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 05:20:15 -0400
Date: Wed, 04 Jun 2008 18:20:18 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Paul Menage" <menage@google.com>
Subject: Re: [PATCH] cgroup: list_for_each cleanup
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       "Li Zefan" <lizf@cn.fujitsu.com>
In-Reply-To: <6599ad830806040211t31d86c57o6836f7cc34faf7f7@mail.gmail.com>
References: <20080604172812.941C.KOSAKI.MOTOHIRO@jp.fujitsu.com> <6599ad830806040211t31d86c57o6836f7cc34faf7f7@mail.gmail.com>
Message-Id: <20080604181901.941F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -       while (!list_empty(&release_list)) {
> > +
> > +       list_for_each_entry_safe(cgrp, saved_cgrp, &release_list,
> > +                                release_list) {
> >                char *argv[3], *envp[3];
> >                int i;
> >                char *pathbuf;
> > -               struct cgroup *cgrp = list_entry(release_list.next,
> > -                                                   struct cgroup,
> > -                                                   release_list);
> > +
> 
> I don't think that list_for_each_entry_safe() is still safe when we've
> dropped release_list_lock. saved_cgroup could end up pointing to a
> cgroup that's freed while we're forking the usermode helper.

Ah, you are right.
I'll drop this portion and resend patch.

Thanks.


