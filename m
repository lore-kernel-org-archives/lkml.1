Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbYEYHbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbYEYHbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 03:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYEYHbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 03:31:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:32539 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbYEYHbD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 03:31:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=I89NXyukYhmv1Ko7/OutHewlYAFEq0OG2FQ4K3dcO0E7FIQw1hXST2oY88x0r40hPV9xttNyDhcPVq6EoKrchN0t6vILsCr14TpsMv+rNa27tiHZ4amIRj7lh2REbxJ2cdQXuFpeC3yYluuTsH4lBCWxXLEh98vej80UF3L6vJU=
Message-ID: <84144f020805250031k67264c69ub8502fd7f9b57f3f@mail.gmail.com>
Date: Sun, 25 May 2008 10:31:02 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "=?ISO-8859-1?Q?Kristian_H=F8gsberg?=" <krh@redhat.com>
Subject: Re: [PATCH 2/2 v2] Only print "Decompressing Linux" etc when 'debug' is passed.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1211687267-12962-1-git-send-email-krh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1211687267-12962-1-git-send-email-krh@redhat.com>
X-Google-Sender-Auth: 8e22f84e4e95f002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 6:47 AM, Kristian Høgsberg <krh@redhat.com> wrote:
> @@ -461,9 +483,11 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
>  #endif
>
>        makecrc();
> -       putstr("\nDecompressing Linux... ");
> +       if (debug)
> +               putstr("\nDecompressing Linux... ");
>        gunzip();
>        parse_elf(output);
> -       putstr("done.\nBooting the kernel.\n");
> +       if (debug)
> +               putstr("done.\nBooting the kernel.\n");
>        return;
>  }

Please add a proper changelog explaining why we want to do this.
