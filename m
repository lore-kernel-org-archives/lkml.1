Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbYKURov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbYKURov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbYKURom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:44:42 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:54331 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbYKURol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:44:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pFFzF65J60yoDCSdPi3zGDkKoeM/2z9a4QywDFDqoPgaooT9xJDb7mfrpBGeZKckad
         Gd7v1/pgxpeuIVy+bszcNUwAgey0rzBA8vMW6tbz4NKUlkQOOSi0fDp54EpwgKkm+Anu
         UwceaGaHFHF2QsNEqf0O2SeE51KnNk5AVSHFo=
Date: Fri, 21 Nov 2008 17:44:26 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jdike@addtoit.com
Subject: Re: uml: using hostfs as rootfs is not working
Message-ID: <20081121174426.GB23653@hack.voiplan.pt>
References: <alpine.LNX.1.10.0811191930090.4486@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0811191930090.4486@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 07:32:16PM +0100, Jan Engelhardt wrote:
>Hi,
>

Hi, Jan!


>
>as per Documentation/uml/*txt, I issued the following to get a direct 
>hostfs:
>
>	./linux ubd0=/tftpboot/linux
>
>(/tftpboot/linux/sbin/init exists), but the UM kernel only gives:
>
>Failed to open '/home/tftpboot/linux', errno = 21


I think this error comes from arch/um/drivers/ubd_kern.c::ubd_open_dev()


>ubda: Can't open "/home/tftpboot/linux": errno = 21

This is from the caller: ubd_open().

ubd_open_dev() calls open_ubd_file() to open the ubd device, which, in
turn, calls os_open_file() which is a wrapper of open64().

And errno 21 should be EISDIR, for open(), which means we invoked it
with a writing operation, probably O_RDWR...

So I think there must be something wrong in the code, writing to a
directory is suspicious...

I will try to check it.

Thank you!

-- 
"Sometimes the only way to stay sane is to go a little crazy."

