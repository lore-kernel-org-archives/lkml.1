Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbYABOhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbYABOhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 09:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbYABOh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 09:37:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbYABOh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 09:37:28 -0500
Date: Wed, 2 Jan 2008 09:37:19 -0500
From: Rik van Riel <riel@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] restrict reading from /proc/<pid>/maps to those who
 share ->mm or can ptrace pid
Message-ID: <20080102093719.4f9bc413@bree.surriel.com>
In-Reply-To: <20080102140957.GR27894@ZenIV.linux.org.uk>
References: <20080102140957.GR27894@ZenIV.linux.org.uk>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2008 14:09:57 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> 	Contents of /proc/*/maps is sensitive and may become sensitive
> after open() (e.g. if target originally shares our ->mm and later
> does exec on suid-root binary).
> 	Check at read() (actually, ->start() of iterator) time that
> mm_struct we'd grabbed and locked is
> 	* still the ->mm of target
> 	* equal to reader's ->mm or the target is ptracable by reader.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
