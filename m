Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbZGULJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbZGULJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 07:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbZGULJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 07:09:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:38536 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbZGULJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 07:09:43 -0400
Subject: Re: [Patch] pipe: use file_update_time() when hold i_mutex
From: Miklos Szeredi <mszeredi@suse.cz>
To: Amerigo Wang <amwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       heiko.carstens@de.ibm.com, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk
In-Reply-To: <4A65934B.9050904@redhat.com>
References: <20090706053745.6338.50777.sendpatchset@localhost.localdomain>
	 <20090720141150.e9d081ca.akpm@linux-foundation.org>
	 <4A65934B.9050904@redhat.com>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 13:09:40 +0200
Message-Id: <1248174580.28516.595.camel@tucsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-21 at 18:07 +0800, Amerigo Wang wrote:
> Andrew Morton wrote:
> > On Mon, 6 Jul 2009 01:35:30 -0400
> > Amerigo Wang <amwang@redhat.com> wrote:
> >
> >   
> >> file_update_time() should be called with i_mutex held,
> >> move it before mutex_unlock().
> >>
> >>     
> >
> > Why do you believe that file_update_time() needs i_mutex?
> >   
> file_update_time() modifies inode, no? :)

So does touch_atime(), yet neither needs i_mutex.

But calling file_update_time() within the locked region in pipe_write()
might make sense regardless: that way a task waiting for data would be
guaranteed to see the time change after receiving a POLLIN event for
example.

Thanks,
Miklos


