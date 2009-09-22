Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbZIVVjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbZIVVjt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 17:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZIVVjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 17:39:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:50246 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbZIVVjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 17:39:47 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs / Novell
To: Eric Paris <eparis@redhat.com>
Subject: Re: fanotify as syscalls
Date: Tue, 22 Sep 2009 23:38:32 +0200
User-Agent: KMail/1.9.9
Cc: Jamie Lokier <jamie@shareable.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, viro@zeniv.linux.org.uk, alan@linux.intel.com,
       hch@infradead.org
References: <20090912094110.GB24709@ioremap.net> <200909212204.51077.agruen@suse.de> <1253653576.2747.27.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1253653576.2747.27.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909222338.32646.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 22 September 2009 23:06:16 Eric Paris wrote:
> this is true, if there is only one namespace subtree notification works
> the same as global notification.
>
> [...]
>
> I don't see how subtree notification can possibly solve the global
> notification problem.

I'm thinking of is something like this: A listener registers interest in "/", 
recursively. The kernel sets a FSNOTIFY_WATCH_RECURSIVE flag on "/" and each 
mount point below. Afterwards when something is mounted anywhere, same 
namespace or not, the kernel sets the new mount's FSNOTIFY_WATCH_RECURSIVE 
flag if the parent mount has this flag set.

(Of course we need per fsnotify_group flags and not global ones, but this 
doesn't change the principle.)

Andreas
