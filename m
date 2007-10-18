Return-Path: <linux-kernel-owner+w=401wt.eu-S1764692AbXJRUwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764692AbXJRUwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758005AbXJRUwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:52:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758172AbXJRUwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:52:44 -0400
Date: Thu, 18 Oct 2007 16:52:38 -0400
From: Rik van Riel <riel@redhat.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com
Subject: Re: OOM notifications
Message-ID: <20071018165238.0537eaa6@bree.surriel.com>
In-Reply-To: <4717C43D.6030204@keyaccess.nl>
References: <20071018202504.GA2854@dmt>
	<4717C43D.6030204@keyaccess.nl>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 22:38:21 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 10/18/2007 10:25 PM, Marcelo Tosatti wrote:
> 
> > AIX contains the SIGDANGER signal to notify applications to free up
> > some unused cached memory:
> > 
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0007.0/0901.html
> > 
> > There have been a few discussions on implementing such an idea on
> > Linux, but nothing concrete has been achieved.
> > 
> > On the kernel side Rik suggested two notification points: "about to
> > swap" (for desktop scenarios) and "about to OOM" (for embedded-like
> > scenarios).
> > 
> > With that assumption in mind it would be necessary to either have
> > two special devices for notification, or somehow indicate both
> > events through the same file descriptor.
> > 
> > Comments are more than welcome.
> 
> Given the desktop/embedded distinction you made, do you need both
> scenarios active at the same time? If not, it seems something like a
> 
> 	echo -n <level> >/proc/sys/vm/danger
> 
> could do with just one sigdanger notification point? (with <level>
> suitably defined as or in terms of the used threshold value).

If you do that, how are applications to know which of the two
scenarios is happening when they get a signal?

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
