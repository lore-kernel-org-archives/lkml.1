Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbXIBULv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbXIBULv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbXIBULk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:11:40 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:40237 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbXIBULj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:11:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MWEEoEgn3ADOVI8njZItfPo+Q9QNo0p1K2uXBg8ET0z1ZH9XiEgUjBh8fiPoaxcSKgHkHVqeMnXHrfdJvXIzH37pvck6MAbfCO5lv8Cv3jutm4R86aRbLztKywIX+7Fm0ZEMqLPVAaC3yDOPfsAynfTGMfMQgbLKkUHw+KL9Qt0=
Message-ID: <9a8748490709021311q179ab8c6iee7ffb14f6a2eb80@mail.gmail.com>
Date: Sun, 2 Sep 2007 22:11:38 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Satyam Sharma" <satyam@infradead.org>
Subject: Re: [PATCH -mm] sisusbvga: Fix bug and build warnings
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Thomas Winischhofer" <thomas@winischhofer.net>,
       "Greg Kroah-Hartman" <greg@kroah.com>,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <alpine.LFD.0.999.0709030136140.29617@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
	 <alpine.LFD.0.999.0709030136140.29617@enigma.security.iitk.ac.in>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/07, Satyam Sharma <satyam@infradead.org> wrote:
>
> drivers/usb/misc/sisusbvga/sisusb.c: In function 'usb_sisusb_init':
> drivers/usb/misc/sisusbvga/sisusb.c:3321: warning: unused variable 'sisusb'
> drivers/usb/misc/sisusbvga/sisusb.c:3320: warning: unused variable 'retval'
>
> are trivially solved by getting rid of the unused variables.
>
> drivers/usb/misc/sisusbvga/sisusb.c: In function 'sisusb_open':
> drivers/usb/misc/sisusbvga/sisusb.c:2444: warning: 'sisusb' is used uninitialized in this function
>
> is a genuine bug (which will cause oops). We cannot use "sisusb" in
> error path for (!interface), because sisusb will itself be derived
> from "interface" later.
>
> Signed-off-by: Satyam Sharma <satyam@infradead.org>
>
> ---
>
>  drivers/usb/misc/sisusbvga/sisusb.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> --- linux-2.6.23-rc4-mm1/drivers/usb/misc/sisusbvga/sisusb.c(J~(Bfix        2007-09-02 19:06:01.000000000 +0530
> +++ linux-2.6.23-rc4-mm1/drivers/usb/misc/sisusbvga/sisusb.c    2007-09-02 19:10:52.000000000 +0530
> @@ -2440,10 +2440,8 @@ sisusb_open(struct inode *inode, struct
>         struct usb_interface *interface;
>         int subminor = iminor(inode);
>
> -       if (!(interface = usb_find_interface(&sisusb_driver, subminor))) {
> -               dev_err(&sisusb->sisusb_dev->dev, "Failed to find interface(J\(Bn");

Odd how in your patch the line ends with  "(J\(Bn"  but if I look in my
local copy of the source tree I see  "\n".


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
