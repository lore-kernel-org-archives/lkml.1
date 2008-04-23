Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbYDWOYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbYDWOYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 10:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYDWOYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 10:24:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2606 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753605AbYDWOYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 10:24:04 -0400
Date: Wed, 23 Apr 2008 16:23:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nadia.Derbey@bull.net
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       orenl@cs.columbia.edu, nick@nick-andrew.net
Subject: Re: [PATCH 0/4] - v2 -  Object creation with a specified id
Message-ID: <20080423142350.GA9228@ucw.cz>
References: <20080418054459.891481000@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418054459.891481000@bull.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> When restarting a process that has been previously checkpointed, that process
> should keep on using some of its ids (such as its process id, or sysV ipc ids).
> 
> This patch provides a feature that can help ensuring this saved state reuse:
> it makes it possible to create an object with a pre-defined id.
> 
> A first implementation had been proposed 2 months ago. It consisted in
> changing an object's id after it had been created.
> 
> Here is a second implementation based on Oren Ladaan's idea: Oren's suggestion
> was to force an object's id during its creation, rather than 1. create it,
> 2. change its id.
> 
> A new file is created in procfs: /proc/self/task/<my_tid>/next_id.
> This makes it possible to avoid races between several threads belonging to
> the same process.

Ugly...

> When this file is filled with an id value, a structure pointed to by the
> calling task_struct is filled with that id.
> 
> Then, when an object supporting this feature is created, the id present in
> that new structure is used, instead of the default one.
> 
> The syntax is one of:
>    . echo "LONG XX" > /proc/self/task/<my_tid>/next_id
>      next object to be created will have an id set to XX
>    . echo "LONG<n> X0 ... X<n-1>" > /proc/self/task/<my_tid>/next_id
>      next object to be created will have its ids set to XX0, ... X<n-1>
>      This is particularly useful for processes that may have several ids if
>      they belong to nested namespaces.

So ugly it is not even funny.

Create fork_with_pid(int pid) and corresponding ipc primitives, if
you have to...
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
