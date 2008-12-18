Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753445AbYLRCca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYLRCca (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 21:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbYLRCcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 21:32:19 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55434 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbYLRCcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 21:32:19 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] sys_execve and sys_uselib do not call into fsnotify
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hch@infradead.org
In-Reply-To: <1229540000.3384.40.camel@localhost.localdomain>
References: <1229540000.3384.40.camel@localhost.localdomain>
Message-Id: <20081218112928.6165.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 18 Dec 2008 11:32:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> sys_execve and sys_uselib do not call into fsnotify so inotify does not get
> open events for these types of syscalls.  This patch simply makes the
> requisite fsnotify calls.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

I hope append your latter explain into the patch description.

> I could be convinced to change it but like what I have.  At this point
> the file is open.  If it fails after this we are going to call fput()
> which calls __fput() which calls fsnotify_close().  Seemed odd to leave
> a close without an open (although that's what we have today.)
> 
> This doesn't mean the syscall was successful, but the file was opened,
> and it will be closed....

I think open/close pairing is important thing to this patch.


Otherthings, looks good to me. very thanks.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



