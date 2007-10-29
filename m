Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbXJ2RLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbXJ2RLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbXJ2RLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:11:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:4609 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbXJ2RLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:11:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NIOvWUe+M1jG9doC7oGmnNNE/7Gr4Xg+kH8Al0/O7J1gCX4AgzUi5H1QrM2BKJPk8rqadt2Nk0nU75+MweqVUX0/arxZ2daKn/jlbBCL3DYPDLdbvQFUhx3Kl8Mud71jP9q7b4KxWB4Ym31H9TmarTJER+0zH3SqYLk/nCnERpY=
Message-ID: <d120d5000710291011u19baaf2avaef6d4b9e5ce003b@mail.gmail.com>
Date: Mon, 29 Oct 2007 13:11:40 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Hohndel, Dirk" <hohndel@linux.intel.com>
Subject: Re: [PATCH] INPUT: fix hidinput_connect ignoring retval from input_register_device
Cc: "Jeff Garzik" <jeff@garzik.org>, "Jiri Kosina" <jikos@jikos.cz>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <3CE5A712-C0BE-45EE-9171-C3B54F789483@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4725F2DF.1060500@garzik.org>
	 <20071029152050.GA23411@bigserver.hohndel.org>
	 <d120d5000710290833i5ed524d6ne95fc1ef34834566@mail.gmail.com>
	 <3CE5A712-C0BE-45EE-9171-C3B54F789483@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/07, Hohndel, Dirk <hohndel@linux.intel.com> wrote:
>
> On Oct 29, 2007, at 8:33 AM, Dmitry Torokhov wrote:
>
> > On 10/29/07, Dirk Hohndel <hohndel@linux.intel.com> wrote:
> >>
> >> Actually, the more I look at the code that bails when it runs out
> >> of memory,
> >> the more I wonder about that.
> >>
> >>        hidinput = kzalloc(sizeof(*hidinput), GFP_KERNEL);
> >>        input_dev = input_allocate_device();
> >>        if (!hidinput || !input_dev) {
> >>                kfree(hidinput);
> >>                input_free_device(input_dev);
> >>
> >> This either passes a NULL pointer to kfree or to
> >> input_free_device. That's
> >> not nice.
> >>
> >
> > No, that's allright. input_free_device() takes after kfree() so that
> > it safe to call it with NULL pointer.
>
> Ahh - should have checked that.
>
> Will the rest of the patch work with the call to hidinput_disconnect?

Yes, I think it will.

-- 
Dmitry
