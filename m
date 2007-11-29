Return-Path: <linux-kernel-owner+w=401wt.eu-S1762371AbXK2PG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762371AbXK2PG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 10:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756567AbXK2PGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 10:06:20 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36810 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbXK2PGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 10:06:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [patch -mm 2/4] mqueue namespace : add unshare support
References: <20071128163728.177495768@fr.ibm.com>
	<20071128164349.196734045@fr.ibm.com>
Date: Thu, 29 Nov 2007 08:03:44 -0700
In-Reply-To: <20071128164349.196734045@fr.ibm.com>> (Cedric Le Goater's
	message of "Wed, 28 Nov 2007 17:37:30 +0100")
Message-ID: <m1y7chccvj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater <clg@fr.ibm.com> writes:

> From: Cedric Le Goater <clg@fr.ibm.com>
>
> This patch includes the mqueue namespace in the nsproxy object. It  
> also adds the support of unshare() and clone() with a new clone flag 
> CLONE_NEWMQ (1 bit left in the clone flags !)
>
> CLONE_NEWMQ is required to be cloned or unshared along with CLONE_NEWNS.
> This is to make sure that no user mounts of the internal mqueue fs
> are left behind when the last task exits. 

Sounds reasonable.  It would be cool if we didn't have to do this.
(Why isn't the mqueue fs not MS_NOUSER?)  Ah well.

I'm not certain about requiring CLONE_NEWNS but it looks to be
ugly if we try and work it the other way.

> It's totally harmless for the moment because the current code still 
> uses the default mqueue namespace object 'init_mq_ns' 

I don't believe the harmless part.  Creating new objects should really
come after we have the code to really make them work.  In some sense
the next patch which makes this work causes ABI breakage.  Closely
packed together it doesn't matter but...

Eric
