Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbXJAPWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbXJAPWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbXJAPV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:21:59 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57733 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbXJAPV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:21:58 -0400
Date: Mon, 1 Oct 2007 21:02:47 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH] Add sysfs control to modify a user's cpu share
Message-ID: <20071001153247.GE5724@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <1190724893.13716.8.camel@Homer.simpson.net> <20070925131717.GM26289@linux.vnet.ibm.com> <1190725693.13716.10.camel@Homer.simpson.net> <20070925132528.GN26289@linux.vnet.ibm.com> <1190726682.11260.1.camel@Homer.simpson.net> <20070925140559.GB26310@linux.vnet.ibm.com> <20070925143755.GA15594@elte.hu> <20070926210737.GA8663@elte.hu> <20071001140454.GA19439@linux.vnet.ibm.com> <20071001144402.GA3505@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001144402.GA3505@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 04:44:02PM +0200, Ingo Molnar wrote:
> but there seems to be a bug in it, i get this:
> 
>  kobject_add failed for 500 with -EEXIST, don't try to register things with the same name in the same directory.

Looks like a remove_dir/create_dir race ..

	free_user()			alloc_uid()

	   uid_hash_remove(up);

					uid_hash_insert(new, hashent);

	   schedule_work()
					user_kobject_create();
					kobject_add();	-> Boom!

	   remove_user_sysfs_dir();

/me looks up sysfs programming examples ..

-- 
Regards,
vatsa
