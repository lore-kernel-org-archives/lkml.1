Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYAEJtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYAEJtR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 04:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbYAEJtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 04:49:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40528 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbYAEJtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 04:49:04 -0500
Date: Sat, 5 Jan 2008 09:48:59 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [PATCH] restrict reading from /proc/<pid>/maps to those who share ->mm or can ptrace pid
Message-ID: <20080105094859.GJ27894@ZenIV.linux.org.uk>
References: <20080102140957.GR27894@ZenIV.linux.org.uk> <20080105013109.4b300cf5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080105013109.4b300cf5.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2008 at 01:31:09AM -0800, Andrew Morton wrote:
> On Wed, 2 Jan 2008 14:09:57 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > 	Contents of /proc/*/maps is sensitive and may become sensitive
> > after open() (e.g. if target originally shares our ->mm and later
> > does exec on suid-root binary).
> 
> um, which contents?

Information about the addresses where libraries, etc. got mapped, to
start with - if you have that randomized, you don't want it seen
by attacker who tries to escalate...
 
> > 	Check at read() (actually, ->start() of iterator) time that
> > mm_struct we'd grabbed and locked is
> > 	* still the ->mm of target
> > 	* equal to reader's ->mm or the target is ptracable by reader.
> > 
> 
> Specifically, do /proc/pid/smaps and the maps4 goodies in -mm need similar
> treatment?

They differ only in ->show(), so this patch takes care of them as well...
