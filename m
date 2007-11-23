Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbXKWEYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbXKWEYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 23:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbXKWEXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 23:23:55 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:46342 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbXKWEXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 23:23:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N9QVCVq199Isy5ytma8Avp6Y17ZTDtsJ7oq4d5y3HrbMamFCVc5et02+CL1d9bSdZsR7ptKZrI+aEvk4xvWbsf21gW5bETAhQz6sUMHwVcTQF3oLXvhqva/lYlTP4by/BU3W7cprgvVuZhxjdtADfVlLMHUjBikFeEBAwbxk74I=
Message-ID: <aa79d98a0711222023l31cdec98o47f56e3c87886a02@mail.gmail.com>
Date: Fri, 23 Nov 2007 07:23:54 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: [PATCH] PPC: CHRP - fix possible NULL pointer dereference
Cc: PPCML <linuxppc-dev@ozlabs.org>, "Olof Johansson" <olof@lixom.net>,
       "Paul Mackerras" <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071123101646.63550945.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071122195423.GA9877@cvg>
	 <20071123101646.63550945.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/07, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Thu, 22 Nov 2007 22:54:23 +0300 Cyrill Gorcunov <gorcunov@gmail.com>
> wrote:
> >
> > This patch does fix possible NULL pointer dereference
> > inside of strncmp() if of_get_property() failed.
>
> Thanks for this.
>
> >  static void __init sio_init(void)
> >  {
> >   struct device_node *root;
> > + const char *model = NULL;
>
> You don't need this initialization as you always assign the variable
> before you use it.
>
> > + root = of_find_node_by_path("/");
> > + if (root) {
>
>  if (!root)
>   return;
>
> would save a level of indentation. Not important.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
Oh my :) Thanks. I'll fix it and resend.
