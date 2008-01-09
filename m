Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbYAIMp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbYAIMp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYAIMpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:45:12 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:47647 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYAIMpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:45:10 -0500
Date: Wed, 9 Jan 2008 13:45:09 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: haveblue@us.ibm.com, akpm@linux-foundation.org, hch@infradead.org,
       serue@us.ibm.com, viro@ftp.linux.org.uk, ebiederm@xmission.com,
       kzak@redhat.com, linux-fsdevel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 5/9] unprivileged mounts: allow unprivileged bind mounts
In-Reply-To: <E1JCJoQ-0003g9-Nk@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0801091340270.29244@fbirervta.pbzchgretzou.qr>
References: <20080108113502.184459371@szeredi.hu>  <20080108113626.895583537@szeredi.hu>
 <1199815958.9834.58.camel@localhost> <E1JCJoQ-0003g9-Nk@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 8 2008 20:08, Miklos Szeredi wrote:
>> On Tue, 2008-01-08 at 12:35 +0100, Miklos Szeredi wrote:
>> > +static int reserve_user_mount(void)
>> > +{
>> > +       int err = 0;
>> > +
>> > +       spin_lock(&vfsmount_lock);
>> > +       if (nr_user_mounts >= max_user_mounts && !capable(CAP_SYS_ADMIN))
>> > +               err = -EPERM;
>> > +       else
>> > +               nr_user_mounts++;
>> > +       spin_unlock(&vfsmount_lock);
>> > +       return err;
>> > +} 
>> 
>> Would -ENOSPC or -ENOMEM be a more descriptive error here?  
>
>The logic behind EPERM, is that this failure is only for unprivileged
>callers.  ENOMEM is too specifically about OOM.  It could be changed
>to ENOSPC, ENFILE, EMFILE, or it could remain EPERM.  What do others
>think?

ENOSPC: No space remaining on device => 'wth'.
ENOMEM: I usually think of a userspace OOM (e.g. malloc'ed out all of your
32-bit address space on 32-bit processes)
EMFILE: "Too many open files"
ENFILE: "Too many open files in system".

ENFILE seems like a temporary winner among these four.

Back in the old days, when the number of mounts was limited in Linux,
what error value did it return? That one could be used.
