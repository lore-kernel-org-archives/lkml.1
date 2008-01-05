Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYAEJbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYAEJbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 04:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755109AbYAEJbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 04:31:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56490 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755068AbYAEJbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 04:31:20 -0500
Date: Sat, 5 Jan 2008 01:31:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [PATCH] restrict reading from /proc/<pid>/maps to those who
 share ->mm or can ptrace pid
Message-Id: <20080105013109.4b300cf5.akpm@linux-foundation.org>
In-Reply-To: <20080102140957.GR27894@ZenIV.linux.org.uk>
References: <20080102140957.GR27894@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2008 14:09:57 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:

> 	Contents of /proc/*/maps is sensitive and may become sensitive
> after open() (e.g. if target originally shares our ->mm and later
> does exec on suid-root binary).

um, which contents?

> 	Check at read() (actually, ->start() of iterator) time that
> mm_struct we'd grabbed and locked is
> 	* still the ->mm of target
> 	* equal to reader's ->mm or the target is ptracable by reader.
> 

Specifically, do /proc/pid/smaps and the maps4 goodies in -mm need similar
treatment?

