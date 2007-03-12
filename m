Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbXCLUb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbXCLUb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbXCLUb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:31:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:22081 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbXCLUb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:31:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IIOT6A1oOtCcU/XdbGqPjZbEf7WctLlH0XKBLJCFgPgxeXOTFTLeTK0loHsNvFxHpv7ElGrwupUV4Nqc0i2VPLK5xLpWrRAQbwYQPBCzcPJxtUSoHJ+K7/To0oPaKvebUj73XrLbczS558nC82j96ZFm6VV3hZ6rdTMYF/9TWxs=
Message-ID: <d120d5000703121331s73fa5462p5da58ba391ea7101@mail.gmail.com>
Date: Mon, 12 Mar 2007 16:31:17 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
Cc: "Oliver Neukum" <oneukum@suse.de>, "Maneesh Soni" <maneesh@in.ibm.com>,
       gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0703121557360.4003-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703122049.03113.oneukum@suse.de>
	 <Pine.LNX.4.44L0.0703121557360.4003-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 12 Mar 2007, Oliver Neukum wrote:
>
> > > >  I don't like reverting my own code. But I predict he'll tell you that a
> > > > driver's bond with a device should be represented in a data structure
> > > > that is to be refcounted.
> > >
> > > :-)
> >
> > Coming to think about it, he might be right there.
>
> There still would be a synchronization problem.  Refcounts don't solve
> races; they only solve lifetime problems.  And you would still have to
> change the sysfs API, plus all the other stuff...
>
> Do you think Linus would listen if all three of us (plus maybe Greg) tried
> to convince him?
>

If we'd accompany the argument with the patch that changes scsi to use
wq to perform deletion so we don't have deadlock regression in the
kernel he might be more perceptive... He is right about lifetime
issues but this is not strictly lifetime issue as you correctly point
out. Plus, refcounting also bloats the kernel so I don't relly want to
use refcount for every integer I happen to export through sysfs if I
can simply "revoke" access.

-- 
Dmitry
