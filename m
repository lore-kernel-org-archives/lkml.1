Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbYJ1VwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbYJ1VwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYJ1VwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:52:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51961 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbYJ1VwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:52:14 -0400
To: ncunningham@crca.org.au
CC: miklos@szeredi.hu, rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-reply-to: <1225229399.9661.13.camel@nigel-laptop> (message from Nigel
	Cunningham on Wed, 29 Oct 2008 08:29:59 +1100)
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen
	filesystems.
References: <1224886068.6478.21.camel@nigel-laptop>
	 <E1KuQ1J-0002Vw-9Q@pomaz-ex.szeredi.hu>
	 <1225106427.26724.5.camel@nigel-laptop>  <200810271237.40049.rjw@sisk.pl>
	 <1225107607.26724.9.camel@nigel-laptop>
	 <E1KuRN4-0002gS-Hq@pomaz-ex.szeredi.hu>
	 <1225141168.26724.23.camel@nigel-laptop>
	 <E1KuZKt-0003jl-2N@pomaz-ex.szeredi.hu>
	 <1225145607.26724.54.camel@nigel-laptop>
	 <E1Kuv87-00064p-Lk@pomaz-ex.szeredi.hu> <1225229399.9661.13.camel@nigel-laptop>
Message-Id: <E1KuwTn-0006EQ-8J@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 28 Oct 2008 22:51:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2008, Nigel Cunningham wrote:
> > However it does not fix the freezing of tasks which are waiting for
> > VFS locks (i.e. inode->i_mutex) held by the outstanding fuse requests.
> > This is the tricky part...
> 
> Convert them all to wait_event_freezeable.

You mean convert mutexes to event queues?  Not a very good idea.

I fear we are going down the same path as the last time.  I still
don't think rewriting the VFS is the right solution to the freezing
problem.  But hey, if you want, sumbit a patch or an RFD and lets see
what others think.

Miklos
