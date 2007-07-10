Return-Path: <linux-kernel-owner+w=401wt.eu-S1761341AbXGJA3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341AbXGJA3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 20:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759931AbXGJA3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 20:29:38 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58429 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759697AbXGJA3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 20:29:37 -0400
Date: Mon, 9 Jul 2007 17:29:29 -0700
From: sukadev@us.ibm.com
To: Pavel Emelianov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 0/16] Pid namespaces
Message-ID: <20070710002929.GA11549@us.ibm.com>
References: <468DF6F7.1010906@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468DF6F7.1010906@openvz.org>
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov [xemul@openvz.org] wrote:
| This is "submition for inclusion" of hierarchical, not kconfig
| configurable, zero overheaded ;) pid namespaces.
| 
| The overall idea is the following:
| 
| The namespace are organized as a tree - once a task is cloned
| with CLONE_NEWPIDS (yes, I've also switched to it :) the new

Can you really clone() a pid namespace all by itself ?
copy_namespaces() has the following:


        if (!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC | CLONE_NEWUSER)))
                return 0;

doesn't it mean you cannot create a pid namespace using clone() unless
one of the above flags are also specified ?

unshare_nsproxy_namespaces() has the following correct check:

        if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
                               CLONE_NEWUSER | CLONE_NEWPIDS)))
                return 0;

BTW, why not use CLONE_NEWPID and drop the 'S' ? We don't have 'S' with
other namespaces.

Suka
