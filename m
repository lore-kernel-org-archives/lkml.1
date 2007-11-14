Return-Path: <linux-kernel-owner+w=401wt.eu-S1762060AbXKNE4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762060AbXKNE4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 23:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbXKNE4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 23:56:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36377 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757296AbXKNE43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 23:56:29 -0500
Date: Tue, 13 Nov 2007 20:55:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: 2.6.24-rc2-mm1
Message-Id: <20071113205544.2a7743b4.akpm@linux-foundation.org>
In-Reply-To: <473A6E72.60503@googlemail.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<473A6E72.60503@googlemail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 04:41:38 +0100 Gabriel C <nix.or.die@googlemail.com> wrote:

> Uff clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch *really* spams.
> Looks like some programs are using this 'deprecated flag'. 
> 
> Could this have some CONFIG_SPAM_ME_PLEASE ?;)
> 
> This is what I got in some minutes :
> 
> 
> --dmesg|grep 'used deprecated clone flags'|sed 's/.*] //'|sort -u
> fork(): process `artsd' used deprecated clone flags 0x400000
> fork(): process `firefox-bin' used deprecated clone flags 0x400000
> fork(): process `gcompris' used deprecated clone flags 0x400000
> fork(): process `qgit' used deprecated clone flags 0x400000
> fork(): process `thunderbird-bin' used deprecated clone flags 0x400000
> fork(): process `wish' used deprecated clone flags 0x400000
> fork(): process `xchat' used deprecated clone flags 0x400000
> fork(): process `kdbus' used deprecated clone flags 0x400000
> 
> --dmesg|grep 'used deprecated clone flags'|wc -l
> 151

hm, that was supposed to shut itself off after 100 messages:

	if (unlikely(clone_flags & (CLONE_DETACHED|CLONE_STOPPED))) {
		static int __read_mostly count = 100;

		if (count && printk_ratelimit()) {
			char comm[TASK_COMM_LEN];

			count--;
			printk(KERN_INFO "fork(): process `%s' used deprecated "
					"clone flags 0x%lx\n",
				get_task_comm(comm, current),
				clone_flags & (CLONE_DETACHED|CLONE_STOPPED));
		}
	}

I don't see how you got 151 instances.  I guess I'm having another stupid
day.

Oh well.  That's CLONE_DETACHED and I think Ulrich's question just got
answered.

Which distro/version are you running?

Thanks for letting us know....
