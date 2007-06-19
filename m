Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbXFSOV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbXFSOV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbXFSOVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:21:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:64799 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbXFSOVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:21:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tT+LQtx01T3IlgoqagpdTvQmmEvUIyaSeovXiNJTfKCUkVNDas/YB5gOd+mpPEXZWGnBzAf9NIU/vNUUG8cHPVWGd8iSPZKfAbT1A7TDK/WTQHAwe5yNe+nWPSwdcUbXf+H3LbnEC1wOR/RzgpQA3ak0lCMyxaCghkhBDyZWryk=
Message-ID: <a781481a0706190721x6e4c5e66wdf98cf257ee48f4a@mail.gmail.com>
Date: Tue, 19 Jun 2007 19:51:15 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Keiichi KII" <k-keiichi@bx.jp.nec.com>
Subject: Re: [RFC][PATCH -mm take5 4/7] using symlink for the net_device
Cc: "Matt Mackall" <mpm@selenic.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <4677AA06.4090600@bx.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466FC455.5060001@bx.jp.nec.com> <466FC6ED.9060208@bx.jp.nec.com>
	 <a781481a0706130949j7b35e33ds9cda5d8a551c9d7d@mail.gmail.com>
	 <4677AA06.4090600@bx.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keiichi,

On 6/19/07, Keiichi KII <k-keiichi@bx.jp.nec.com> wrote:
> Hello Satyam,
>
> > Sorry, but we're not covering from the error condition fully here. Note
> > that later you merge the temporary modify_target_list entirely back
> > into the target_list ... which would still contain these erroneous
> > nodes. A full cleanup (kobject_unregister the entry, and then list_del
> > from modify_target_list) is required here, before continuing.
>
> I will fix this. If the error occurs, I think so that we need to cleanup
> completely.

Yes, thanks.

> >> +                       strcpy(nt->np.dev_name, dev->name);
> >
> > ... you'll have move this up.
> >
>
> Why? I don't have opposition about moving this up, but I'm misplacing the abobe code?
> or it isn't appropriate about coding style?

As I said, _either_ you stick a "continue;" after recovering from the
error above this code (i.e. if the sysfs_create_link() just above this
line fails), _or_ you'll have to move the strcpy() up (above the
sysfs_create_link). Note that recovering fully would mean
unregistering the kobject for that target, deleting the node from the
modify_list and kfree'ing the struct netconsole_target *nt (otherwise
we'll have a memory leak on our hands). And if we've kfree'd nt, we'll
oops on trying to dereference it like we're doing in the strcpy here.

Thanks,
Satyam
