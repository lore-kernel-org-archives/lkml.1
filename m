Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbZJ0Gqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbZJ0Gqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 02:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756350AbZJ0Gqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 02:46:39 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60921 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316AbZJ0Gqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 02:46:38 -0400
Date: Tue, 27 Oct 2009 15:46:36 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: Memory overcommit
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       vedran.furac@gmail.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091027153429.b36866c4.minchan.kim@barrios-desktop>
References: <2f11576a0910262310g7aea23c0n9bfc84c900879d45@mail.gmail.com> <20091027153429.b36866c4.minchan.kim@barrios-desktop>
Message-Id: <20091027154429.E2A4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > %check_badness.pl | sort -n | tail
> > > --
> > > 89924   3938    mixer_applet2
> > > 90210   3942    tomboy
> > > 94753   3936    clock-applet
> > > 101994  3919    pulseaudio
> > > 113525  4028    gnome-terminal
> > > 127340  1       init
> > > 128177  3871    nautilus
> > > 151003  11515   bash
> > > 256944  11653   mmap
> > > 425561  3829    gnome-session
> > > --
> > > Sigh, gnome-session has twice value of mmap(1G).
> > > Of course, gnome-session only uses 6M bytes of anon.
> > > I wonder this is because gnome-session has many children..but need to
> > > dig more. Does anyone has idea ?
> > > (CCed kosaki)
> > 
> > Following output address the issue.
> > The fact is, modern desktop application linked pretty many library. it
> > makes bloat VSS size and increase
> > OOM score.
> > 
> > Ideally, We shouldn't account evictable file-backed mappings for oom_score.
> > 
> Hmm. 
> I wonder why we consider VM size for OOM kiling. 
> How about RSS size?

Because, swap out-ed bad body (e.g. fork bomb process) still should
be killed by oom.
RSS + swap-entries is acceptable to me.



