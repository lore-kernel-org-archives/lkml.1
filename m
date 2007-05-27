Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbXE0Wla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbXE0Wla (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 18:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbXE0WlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 18:41:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:46912 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbXE0WlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 18:41:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CXWOlVw4U8A/U67nKD2Gp9zgb+qh5F3xzzX/95S5Gz+Ym8Ebb7e9Zg35MXCk/S8171Pkqvq0DacyiSxlk7Qz0zbT6Z4vv++p84SM+a6b5TJc2IhQodEFbe9tMdKD6A9Dj5A/Y2DytChb7zGR67e/p2C5r3eH3WhXutaHkwOZRLM=
Message-ID: <3ae72650705271541o2c3755edwdc769883e79820e5@mail.gmail.com>
Date: Mon, 28 May 2007 00:41:19 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Tilman Schmidt" <tilman@imap.cc>
Subject: Re: 2.6.22-rc2-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Cornelia Huck" <cornelia.huck@de.ibm.com>, "Greg KH" <greg@kroah.com>
In-Reply-To: <465A033C.3070400@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	 <46585953.80200@imap.cc>
	 <20070526090117.dda72286.akpm@linux-foundation.org>
	 <465A033C.3070400@imap.cc>
X-Google-Sender-Auth: 22539be168566499
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Tilman Schmidt <tilman@imap.cc> wrote:
> Am 26.05.2007 18:01 schrieb Andrew Morton:
> > On Sat, 26 May 2007 17:59:15 +0200 Tilman Schmidt <tilman@imap.cc> wrote:
>
> >> This breaks network initialization on my SuSE 10.0 box [...]
> >
> > Thanks.  I think others have seen similar things and it was attributed to
> > driver-core-check-return-code-of-sysfs_create_link.patch.
>
> That's it. After reverting that patch, the Ethernet interface
> comes up fine again.

Cornelia,
in the patch is:
  +	if (dev->kobj.parent == &dev->class->subsys.kobj)
  +		return 0;

which will skip the creation of the "device"-link, right?

But still, I don't think the transaction-style of error handling is
what we want, it's for some critical subsystems the equivalent of
adding PANIC(), and this just for a failing symlink-creation. I think
we just want to print the to the logs, and not let the whole core
device registration fail entirely.

Thanks,
Kay
