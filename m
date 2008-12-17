Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751932AbYLQTXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbYLQTXR (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYLQTW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:22:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46591 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbYLQTW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:22:59 -0500
Subject: Re: [PATCH] sys_execve and sys_uselib do not call into fsnotify
From: Eric Paris <eparis@redhat.com>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, hch@infradead.org
In-Reply-To: <20081217190433.GA31115@gambetta>
References: <1229540000.3384.40.camel@localhost.localdomain>
	 <20081217190433.GA31115@gambetta>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 14:22:21 -0500
Message-Id: <1229541741.3384.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 20:04 +0100, Frederik Deweerdt wrote:
> Hello Eric,
> 
> On Wed, Dec 17, 2008 at 01:53:20PM -0500, Eric Paris wrote:
> > sys_execve and sys_uselib do not call into fsnotify so inotify does not get
> > open events for these types of syscalls.  This patch simply makes the
> > requisite fsnotify calls.
> 
> Just curious, isn't the fact that the open still may fail a problem?
> For example, if the lib is not executable in sys_uselib or if the file
> was denied write access in open_exec.

I could be convinced to change it but like what I have.  At this point
the file is open.  If it fails after this we are going to call fput()
which calls __fput() which calls fsnotify_close().  Seemed odd to leave
a close without an open (although that's what we have today.)

This doesn't mean the syscall was successful, but the file was opened,
and it will be closed....

-Eric

