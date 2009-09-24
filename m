Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZIXSgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZIXSgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbZIXSgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:36:15 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55937 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbZIXSgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:36:14 -0400
Date: Thu, 24 Sep 2009 13:35:56 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v7][PATCH 0/9] Implement clone2() system call
Message-ID: <20090924183556.GA31356@us.ibm.com>
References: <20090924165548.GA16586@us.ibm.com> <20090924175542.GA27678@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924175542.GA27678@x200>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexey Dobriyan (adobriyan@gmail.com):
> I don't like this even more.
> 
> Pid namespaces are hierarchical _and_ anonymous, so simply
> set of numbers doesn't describe the final object.
> 
> struct pid isn't special, it's just another invariant if you like
> as far as C/R is concerned, but system call is made special wrt pids.
> 
> What will be in an image? I hope "struct kstate_image_pid" with several

Sure pid namespaces are anonymous, but we will give each an 'objref'
valid only for a checkpoint image, and store the relationship between
pid namespaces based on those objrefs.  Basically the same way that user
structs and hierarchical user namespaces are handled right now.

> numbers and with references to such object from other places, so it
> seems natural to do alloc_pid() with needed numbers and that attach new
> shiny pid to where needed. But this clone_pid is only for task_struct's pids.
