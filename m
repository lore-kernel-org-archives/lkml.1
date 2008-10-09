Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbYJIM6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbYJIM6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 08:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756585AbYJIM6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 08:58:47 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46421 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbYJIM6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 08:58:47 -0400
Subject: Re: [RFC v6][PATCH 0/9] Kernel based checkpoint/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oren Laadan <orenl@cs.columbia.edu>, jeremy@goop.org, arnd@arndb.de,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20081009124658.GE2952@elte.hu>
References: <1223461197-11513-1-git-send-email-orenl@cs.columbia.edu>
	 <20081009124658.GE2952@elte.hu>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 05:58:42 -0700
Message-Id: <1223557122.11830.14.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 14:46 +0200, Ingo Molnar wrote:
> * Oren Laadan <orenl@cs.columbia.edu> wrote:
> 
> > These patches implement basic checkpoint-restart [CR]. This version 
> > (v6) supports basic tasks with simple private memory, and open files 
> > (regular files and directories only). Changes mainly cleanups. See 
> > original announcements below.
> 
> i'm wondering about the following productization aspect: it would be 
> very useful to applications and users if they knew whether it is safe to 
> checkpoint a given app. I.e. whether that app has any state that cannot 
> be stored/restored yet.

Absolutely!

My first inclination was to do this at checkpoint time: detect and tell
users why an app or container can't actually be checkpointed.  But, if I
get you right, you're talking about something that happens more during
the runtime of the app than during the checkpoint.  This sounds like a
wonderful approach to me, and much better than what I was thinking of.

What kind of mechanism do you have in mind?

int sys_remap_file_pages(...)
{
	...
	oh_crap_we_dont_support_this_yet(current);
}

Then the oh_crap..() function sets a task flag or something?

-- Dave

