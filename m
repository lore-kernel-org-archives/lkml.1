Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbXIMHQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbXIMHQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXIMHQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:16:29 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:32534 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbXIMHQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:16:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=uSVQ5UHWxf5yPFpjFmzEbW9OpXSUVKolSZ6AwP6j3GnK7PzyK7hy+Swm0TVf5Ox9ytHL+8Tdi6lgjEgzl4kAdnGxD88gmnnCwV+L0dzM8JqPKcswfVtOoU/DWD9C4XmtUplT1Y0yvrnn9Hvt2dj0M2Hy+eXYi4KalAwohx2Te/w=
Message-ID: <661de9470709130016pc797964yb300e9923c778a01@mail.gmail.com>
Date: Thu, 13 Sep 2007 12:46:27 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "Pavel Emelyanov" <xemul@openvz.org>
Subject: Re: [PATCH] Memory shortage can result in inconsistent flocks state
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       devel@openvz.org
In-Reply-To: <46E8D2E0.7040507@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46E68C35.7040001@openvz.org> <20070912190653.GA13792@fieldses.org>
	 <46E8D2E0.7040507@openvz.org>
X-Google-Sender-Auth: ede82732f170f8d1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/07, Pavel Emelyanov <xemul@openvz.org> wrote:
> J. Bruce Fields wrote:
> > On Tue, Sep 11, 2007 at 04:38:13PM +0400, Pavel Emelyanov wrote:
> >> This is a known feature that such "re-locking" is not atomic,
> >> but in the racy case the file should stay locked (although by
> >> some other process), but in this case the file will be unlocked.
> >
> > That's a little subtle (I assume you've never seen this actually
> > happen?), but it makes sense to me.
>
> Well, this situation is hard to notice since usually programs
> try to finish up when some error is returned from the kernel,
> but I do believe that this could happen in one of the openvz
> kernels since we limit the kernel memory usage for "containers"
> and thus -ENOMEM is a common error.
>

The fault injection framework should be able to introduce the same
error. Of course hitting the error would require careful setup of the
fault parameters.

Balbir
