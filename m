Return-Path: <linux-kernel-owner+w=401wt.eu-S1422639AbXBPPJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422639AbXBPPJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422643AbXBPPJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:09:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422639AbXBPPJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:09:32 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <45D5B2E3.3030607@hitachi.com> 
References: <45D5B2E3.3030607@hitachi.com> 
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Robin Holt <holt@sgi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v3 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 16 Feb 2007 15:08:54 +0000
Message-ID: <20425.1171638534@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kawai, Hidehiro <hidehiro.kawai.ez@hitachi.com> wrote:

> To avoid the above situation we can limit the core file size by
> setrlimit(2) or ulimit(1). But this method can lose important data
> such as stack because core dumping is terminated halfway.
> So I suggest keeping shared memory segments from being dumped for
> particular processes.

A better way might be to place the shared memory segments last if that's
possible (I'm not sure ELF supports out-of-order segments).

> Because the shared memory attached to processes is common in them, we don't
> need to dump the shared memory every time.

So there's no guarantee that they'll be dumped at all...  I'm not sure there's
any way around that, however.

David
