Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbYARHwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbYARHwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 02:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbYARHwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 02:52:04 -0500
Received: from smtp-out.google.com ([216.239.33.17]:41544 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbYARHwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 02:52:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=W+4fP19QFFVcmJYZotTehevgcCZS9VHyA636nQtBGwQzqy9IjMYcAaC3X7KH9HhRS
	jFypchlkcKqxuj2S2UHRg==
Message-ID: <532480950801172351p7603e8d0icdc8e2b27c1e0051@mail.gmail.com>
Date: Thu, 17 Jan 2008 23:51:51 -0800
From: "Michael Rubin" <mrubin@google.com>
To: "Fengguang Wu" <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 00/13] writeback bug fixes and simplifications take 2
Cc: "Andrew Morton" <akpm@osdl.org>, "Peter Zijlstra" <peterz@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <400401292.24795@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <400401292.24795@ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 15, 2008 4:36 AM, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> Andrew,
>
> This patchset mainly polishes the writeback queuing policies.
> The main goals are:
>
> (1) small files should not be starved by big dirty files
> (2) sync as fast as possible for not-blocked inodes/pages
>     - don't leave them out; no congestion_wait() in between them
> (3) avoid busy iowait for blocked inodes
>     - retry them in the next go of s_io(maybe at the next wakeup of pdflush)
>
> The role of the queues:
>
> s_dirty:   park for dirtied_when expiration
> s_io:      park for io submission
> s_more_io: for big dirty inodes, they will be retried in this run of pdflush
>            (it ensures fairness between small/large files)
> s_more_io_wait: for blocked inodes, they will be picked up in next run of s_io

Quick question to make sure I get this. Each queue is sorted as such:

s_dirty - sorted by the dirtied_when field
s_io - sorted by  no explicit key but by the order we want to process
in sync_sb_inodes
s_more_io - held for later they are sorted in the same manner as s_io

Is that it?

mrubin
