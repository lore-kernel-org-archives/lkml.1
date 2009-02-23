Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbZBWX6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbZBWX6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 18:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZBWX6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 18:58:42 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37471 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbZBWX6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 18:58:41 -0500
Date: Tue, 24 Feb 2009 08:57:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
Subject: Re: Question for remount
Message-Id: <20090224085724.4cc1b3b2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49A20ACE.7020309@cn.fujitsu.com>
References: <20090220190223.e8b4f6a8.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830902200822u6d453340me718bacac3925040@mail.gmail.com>
	<d7928a87d8c1bf661e3a3b64db9fa988.squirrel@webmail-b.css.fujitsu.com>
	<49A20ACE.7020309@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009 10:32:46 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > Paul Menage さんは書きました：
> >> On Fri, Feb 20, 2009 at 2:02 AM, KAMEZAWA Hiroyuki
> >> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >>> 2. /proc/mounts information of release_agent should be updated....
> >>>   when it's overwritten directly.
> >> Yes, definitely. But shouldn't that happen already?
> >> cgroup_show_options() reports the current value of
> >> root->release_agent_path in /proc/mounts. Is it possible that mount is
> >> actually storing/retrieving this information in /etc/mtab, which
> >> doesn't get updated?
> >>
> > Ah, you're right. /proc/mounts is updated but /etc/mtab is not updated.
> > Hmm..from man mount(1), /etc/mtab is not synchronized with /proc/mounts.
> > Do we need to allow release_agent override at remount ?
> > 
> 
> Since we've allowed this behavior, I think we shouldn't disallow it to
> supprise users?
> 
In a bit different stroy, it already surprises a user (me).
for example)

#mount -t cgroup none /cgroups -ocpu,release_agent=hogehoge
#mount -oremount,cpuacct /cgroups,release_agent=xxxx
=> remount fails. because the option "release_agent" appears twice.

#mount -t cgroup none /cgroups -ocpu,release_agent=hogehoge
#mount -t cgroup none /cgroups -oremount,cpuacct /cgroups,release_agent=xxxx
=> remount success.

At least, updating documentation to notice this is necessary I think.


-Kame

