Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbZAIGh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbZAIGh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 01:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZAIGhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 01:37:17 -0500
Received: from smtp-out.google.com ([216.239.45.13]:9147 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbZAIGhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 01:37:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=Yr1Bg0F0Yg94b8ohaFq8P74iPBDhXB0xJNdjcu5vmNRl0J9V0P88v8GeNbAPbXCOb
	R/OB+RnKh2dBBvd95caBQ==
MIME-Version: 1.0
In-Reply-To: <4966EEDD.5070204@cn.fujitsu.com>
References: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830901082226h6d47053cp801dafb67b6e2bc9@mail.gmail.com>
	 <4966EEDD.5070204@cn.fujitsu.com>
Date: Thu, 8 Jan 2009 22:37:10 -0800
Message-ID: <6599ad830901082237l664fb403y386482a577ed185e@mail.gmail.com>
Subject: Re: [RFC][PATCH] NOOP cgroup subsystem
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.24.198.73
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2009 at 10:29 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> Agreed, but it can't work by just removing the checking in cgroup mount option,

Right - it's more complicated than that. There are some places in the
code that rely on the fact that every hierarchy currently has at least
one subsystem (anything that uses find_first_subsystem() for example)
and we'd need to work around that.

Paul

> I just tried it:
>
> static int parse_cgroupfs_options(char *data,
>                                     struct cgroup_sb_opts *opts)
> {
>        ...
> -       if (!opts->subsys_bits)
> -               return -EINVAL;
>        ...
> }
>
>
