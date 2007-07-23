Return-Path: <linux-kernel-owner+w=401wt.eu-S1760591AbXGWROP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591AbXGWROP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758859AbXGWRNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:13:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:31716 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbXGWRNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:13:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MeTWn6Wyzdy7g3QcqxmCiYGupgjcePXCj578lWwj8229CGNG3HztGwC9JSXdAo05pUcBqGcsmzXXVWzNIvtOS9PGpTpkPO+RCtT0/HoYnF/lFZoVru7nXo1kxl4tqCZBBAQAdHo2bYmyymIfPBugf1MBDVKPaSH/bbzus84+nqA=
Message-ID: <a4e6962a0707231013v47683cd0xd35c65c25cb40653@mail.gmail.com>
Date: Mon, 23 Jul 2007 12:13:45 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: lucho@ionkov.net
Subject: Re: CTL_UNNUMBERED (Re: [PATCH] 9p: Don't use binary sysctl numbers.)
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <m1odi5wfjg.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <m1y7h9wpuo.fsf@ebiederm.dsl.xmission.com>
	 <20070721205709.GB5772@martell.zuzino.mipt.ru>
	 <m1odi5wfjg.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Alexey Dobriyan <adobriyan@gmail.com> writes:
>
> >
> > That's separate patch but CTL_UNNUMBERED must die, because it's totally
> > unneeded. If you don't want sysctl(2) interface just SKIP ->ctl_name
> > initialization and save one line for something useful.
>
> As for the 9p code it doesn't seem to need or want a real binary
> interface.  The 9p debug code picking of a semi-random number and not
> patching it into sysctl.h like it should for a binary interface is
> an implementation bug, and a maintenance problem.
>

Now that -rc1 is out, lets talk a bit more about this.  Lucho can you
provide some level of justification of why you went for a sysctl
interface versus something directly accessible within the file system
-- that would seem more on-par with the 9p philosophy.

Perhaps its time for a general cleanup of the debug_level stuff -- it
was always ugly to have it as a global, but there was just no clear
way to have the session structure available everywhere we use it.

               -eric
