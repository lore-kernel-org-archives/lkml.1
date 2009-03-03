Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbZCCBVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbZCCBVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 20:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZCCBVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 20:21:04 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58949 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZCCBVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 20:21:02 -0500
Date: Tue, 3 Mar 2009 10:19:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 0/4] cgroups: show correct file mode
Message-Id: <20090303101941.8c2041b7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49AC84BE.5020501@cn.fujitsu.com>
References: <49AB40BF.4030706@cn.fujitsu.com>
	<6599ad830903021019p3b29c173oc7772af6679d90e0@mail.gmail.com>
	<49AC8307.7090008@cn.fujitsu.com>
	<20090303100827.43d82c3a.kamezawa.hiroyu@jp.fujitsu.com>
	<49AC84BE.5020501@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Mar 2009 09:15:42 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> >> +/**
> >> + * cgroup_file_mode - deduce file mode of a control file
> >> + * @cft: the control file in question
> >> + *
> >> + * returns cftype->mode if ->mode is not 0
> >> + * returns 0644 if it has both a read and a write handler
> >> + * returns 0444 if it has only a read handler
> >> + * returns 0200 if it has only a write hander
> >> + */
> >> +static int cgroup_file_mode(const struct cftype *cft)
> >> +{
> >> +	int mode = 0;
> >> +
> >> +	if (cft->mode)
> >> +		return cft->mode;
> >> +
> >> +	if (cft->read || cft->read_u64 || cft->read_s64 ||
> >> +	    cft->read_map || cft->read_seq_string)
> >> +		mode += 0444;
> >> +
> >> +	if (cft->write || cft->write_u64 || cft->write_s64 ||
> >> +	    cft->write_string || cft->trigger)
> >> +		mode += 0200;
> >> +
> > 
> > += is not |=...
> > 
> 
> Ah, yes, though both happen to result in 0644.
> 
yes but I like |= rather than += in bit ops.

Reviewed-by; KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

