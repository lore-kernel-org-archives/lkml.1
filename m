Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753425AbYLQWws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYLQWws (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 17:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbYLQWwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 17:52:34 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:8136 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbYLQWwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 17:52:33 -0500
Date: Wed, 17 Dec 2008 23:52:28 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kosaki.motohiro@jp.fujitsu.com, hch@infradead.org
Subject: Re: [PATCH] sys_execve and sys_uselib do not call into fsnotify
Message-ID: <20081217225228.GB31115@gambetta>
References: <1229540000.3384.40.camel@localhost.localdomain> <20081217190433.GA31115@gambetta> <1229541741.3384.48.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229541741.3384.48.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 02:22:21PM -0500, Eric Paris wrote:
> On Wed, 2008-12-17 at 20:04 +0100, Frederik Deweerdt wrote:
> > Just curious, isn't the fact that the open still may fail a problem?
> > For example, if the lib is not executable in sys_uselib or if the file
> > was denied write access in open_exec.
> 
> I could be convinced to change it but like what I have.  At this point
> the file is open.  If it fails after this we are going to call fput()
> which calls __fput() which calls fsnotify_close().  Seemed odd to leave
> a close without an open (although that's what we have today.)
> 
> This doesn't mean the syscall was successful, but the file was opened,
> and it will be closed....
OK, thanks for clarifying,

Frederik

