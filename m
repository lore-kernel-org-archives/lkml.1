Return-Path: <linux-kernel-owner+w=401wt.eu-S1751597AbYLMQnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbYLMQnP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 11:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbYLMQnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 11:43:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49038 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYLMQm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 11:42:59 -0500
Subject: Re: [RFC PATCH -v4 11/14] fsnotify: include pathnames with entries
 when possible
From: Eric Paris <eparis@redhat.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       viro@ZenIV.linux.org.uk, hch@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <20081213031920.GG807@ioremap.net>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
	 <20081212215212.27112.73418.stgit@paris.rdu.redhat.com>
	 <20081213031920.GG807@ioremap.net>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 11:42:42 -0500
Message-Id: <1229186562.29167.108.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-13 at 06:19 +0300, Evgeniy Polyakov wrote:
> On Fri, Dec 12, 2008 at 04:52:12PM -0500, Eric Paris (eparis@redhat.com) wrote:
> > When inotify wants to send events to a directory about a child it includes
> > the name of the original file.  This patch collects that filename and makes
> > it available for notification.
> 
> What about extending fsnotify with attributes so that there would be no
> problems extending it with new events and data sent to userspace?

Since struct fsnotify_event is not exported to userspace information may
be collected in there at event creation time.  I actually have a number
of later patches that do this for information that I want to send for
fanotify.

Information can also be stored in the event->private area if only one
group really cares....   (kinda how I store wd for inotify)

Information which is useful to more than 1 group should be added to
struct fsnotify_event and its up to the individual listeners to export
that to userspace anyway they want to.

So absolutely this is completely extensible.

