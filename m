Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760345AbYLQAOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760345AbYLQAOd (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760860AbYLQANL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:13:11 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:47882 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760188AbYLQANJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:13:09 -0500
Subject: Re: [RFC v11][PATCH 03/13] General infrastructure for checkpoint
	restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mike Waychison <mikew@google.com>
Cc: jeremy@goop.org, arnd@arndb.de, containers@lists.linux-foundation.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linux Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <49482F14.1040407@google.com>
References: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu>
	 <1228498282-11804-4-git-send-email-orenl@cs.columbia.edu>
	 <49482394.10006@google.com> <1229465641.17206.350.camel@nimitz>
	 <49482F14.1040407@google.com>
Content-Type: text/plain
Date: Tue, 16 Dec 2008 16:13:03 -0800
Message-Id: <1229472783.17206.358.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-16 at 14:43 -0800, Mike Waychison wrote:
> Hmm, if I'm understanding you correctly, adding ref counts explicitly 
> (like you suggest below)  would be used to let a lower layer defer 
> writes.  Seems like this could be just as easily done with explicits 
> kmallocs and transferring ownership of the allocated memory to the 
> in-kernel representation handling layer below (which in turn queues the 
> data structures for writes).

Yup, that's true.  We'd effectively shift the burden of freeing those
buffers into the cr_write() (or whatever we call it) function.  

But, I'm just thinking about the sys_checkpoint() side.  I need to go
look at the restart code too.

-- Dave

