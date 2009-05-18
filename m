Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbZERUwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbZERUwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZERUwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:52:32 -0400
Received: from smtp-out.google.com ([216.239.45.13]:7323 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbZERUwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:52:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=pS/aQlYX2QdkaIaGWaoD4fCuueSZGfkiUbf75qRqwIsld3AFAMh9JjWpVD6KlXDGS
	fcCiWJs38FyObJEDR7Uyw==
Date: Mon, 18 May 2009 13:52:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Geoffrey Thomas <geofft@mit.edu>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysrq: Don't panic_on_oom if the user requested an OOM
 kill.
In-Reply-To: <1242643274-26733-1-git-send-email-geofft@mit.edu>
Message-ID: <alpine.DEB.2.00.0905181350400.2281@chino.kir.corp.google.com>
References: <1242643274-26733-1-git-send-email-geofft@mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009, Geoffrey Thomas wrote:

> If I specifically request an OOM kill via magic sysrq, I don't want
> panic_on_oom to apply and crash the machine. I ran into this on a server
> with panic_on_oom and automatic reboot after panic configured on the
> assumption that nobody is likely physically present. If I'm able to use
> magic sysrq, though, I can use that to reboot the machine slightly more
> safely, if that's what I wanted.
> 
> This patch adds an extra parameter to out_of_memory to ignore the value
> of sysctl_panic_on_oom, and just proceed with the OOM kill.
> 
> Signed-off-by: Geoffrey Thomas <geofft@mit.edu>

Nack, it's your own fault for asking for panic_on_oom and then not wanting 
it to panic on oom.

Disable /proc/sys/vm/panic_on_oom before invoking the oom killer and then 
reenable it afterwards.
