Return-Path: <linux-kernel-owner+w=401wt.eu-S933189AbXAXHdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189AbXAXHdG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 02:33:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933183AbXAXHdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 02:33:06 -0500
Received: from nz-out-0506.google.com ([64.233.162.238]:7491 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187AbXAXHdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 02:33:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JckmQPCTH8znIy5mkSPPU6Y/+hbiPdbRVINdG2ccBqmDIsKfJTh33okZpF303C5OEBqlNWP1yOHcnGMCnAypRTAMW2/E0VG7F/x7e9OKzRZdS0WlwQ+ElZtqbyW1wZoCTOh0ZWXrPyCRYKJQ71b4pPwOQo5lucrBkHydaZG4Y4M=
Message-ID: <4ae3c140701232333j4772794j6e49da2d32c0b26d@mail.gmail.com>
Date: Wed, 24 Jan 2007 02:33:03 -0500
From: "Xin Zhao" <uszhaoxin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Is it possible to directly call do_path_lookup() in kernel?
In-Reply-To: <4ae3c140701231032xd6eca27td46cc1c25e150e25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4ae3c140701231032xd6eca27td46cc1c25e150e25@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just successfully called do_path_lookup() in my kernel module. I
just removed the "fastcall" from the declaration of do_path_lookup(),
then the problem disappeared. I don't quite understand "fastcall"
though.

Can someone explain it?

Thanks,
-x

On 1/23/07, Xin Zhao <uszhaoxin@gmail.com> wrote:
> Hi,
>
> I tried to call the following code in a kernel module:
>
>         error = do_path_lookup(AT_FDCWD, "/etc/profile.d/glib2.csh",
> LOOKUP_PARENT, &nd);
>
> I exported the function do_path_lookup() using
> "EXPORT_SYMBOL_GPL(do_path_lookup);"
>
> But do_path_lookup() caused the "general protection fault: 0000 [#1]"
> kernel error.
>
> I thought it could be the problem of protection error, so I used the
> following codes to enclose the code that calls do_path_lookup(), but
> still got the same error.
>
>         fs = get_fs ();                                                   /* save previous value */
>         set_fs (KERNEL_DS);                                               /* use kernel limit */
>         ......
>         set_fs(fs);
>
> Any idea on this?
>
> Thanks a lot!
>
> -x
>
