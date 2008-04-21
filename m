Return-Path: <linux-kernel-owner+w=401wt.eu-S1761802AbYDUNmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761802AbYDUNmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbYDUNmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:42:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34569 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171AbYDUNmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:42:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: fault in __d_lookup [Was: 2.6.25-mm1]
Date: Mon, 21 Apr 2008 15:42:30 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org> <20080421094515.GR27459@ZenIV.linux.org.uk> <480C6597.1000701@gmail.com>
In-Reply-To: <480C6597.1000701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804211542.31356.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 21 of April 2008, Jiri Slaby wrote:
> On 04/21/2008 11:45 AM, Al Viro wrote:
> > On Mon, Apr 21, 2008 at 11:37:40AM +0200, Jiri Slaby wrote:
> >> On 04/21/2008 11:06 AM, Al Viro wrote:
> >>> On Mon, Apr 21, 2008 at 10:31:40AM +0200, Jiri Slaby wrote:
> >>>
> >>>        hlist_for_each_entry_rcu(dentry, node, head, d_hash) {
> >>>                struct qstr *qstr;
> >>>
> >>>                if (dentry->d_name.hash != hash)
> >>>                        continue;
> >>>
> >>> walking into node == (struct hlist_node *)0x00f0000000000000...
> >> Yup, true, In the last oops I stuck on memcmp few lines below.
> >>
> >> BTW. it's 100% reproducible after it happens once, but fixable by reboot. 
> >> Any tests I should run (memtest, some printks sticked anywhere)?
> > 
> > Well, if list has such turd in it, you'll certainly hit it every time
> > you walk that list, so 100% reproducible is not surprising.
> > 
> > How well is it reproducible from fresh boot?
> 
> Few days with suspend/resume cycles. This one was booted 12 hours ago, one 
> suspend/resume. Will keep an eye on it and keep you informed.

I think that's exactly the same problem I reported here:
http://lkml.org/lkml/2008/4/20/182
for 2.6.25-git2, so it hit the mainline and seems to be related to RCU.

Thanks,
Rafael
