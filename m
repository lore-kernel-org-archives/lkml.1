Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbXDPSaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbXDPSaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 14:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXDPSaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 14:30:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:5406 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbXDPSaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 14:30:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ovdvdln9CeJUEuwJeIGWuf7z6Txgk0sGkaSxWg3kdEhfmjfzUvLFv3Uz/J3vymThrvKfA4mO+KQIfDvUNjLyxO+qn/fZE3JVgAK2Amub4cMKhB13h1Kc8u0oMMAChQKmjAAGuWD9hR3l1QwSsYqODYPI+zu3UvXJL0pp+5CBY9U=
Message-ID: <d120d5000704161130j7ae89a1eyef89e015f0a3e97f@mail.gmail.com>
Date: Mon, 16 Apr 2007 14:30:17 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Subject: Re: [Patch -mm 0/3] RFC: module unloading vs. release function
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Alan Stern" <stern@rowland.harvard.edu>, "Greg K-H" <greg@kroah.com>,
       "Tejun Heo" <htejun@gmail.com>, "Rusty Russell" <rusty@rustcorp.com.au>
In-Reply-To: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/07, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> Hi,
>
> based on the discussion in "How should an exit routine wait for
> release() callbacks?", I've cooked up some patches that make module
> unload wait until the last reference for a kobject has been dropped.
> This should plug the "release function in already deleted module" race;
> however, if the last kobject_put() from the module containing the
> release function is not in the module's exit function, there's still a
> small window (not sure if and how to plug this).

Unfortunately all this "wait for refcount in module's exit" schemas
lead to the following deadlock:

        rmmod my_module < /path/to/some/file/incrementing/my/refcount

-- 
Dmitry
