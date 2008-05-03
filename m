Return-Path: <linux-kernel-owner+w=401wt.eu-S1760788AbYECGzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbYECGzR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 02:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbYECGzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 02:55:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:65013 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbYECGzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 02:55:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jgeQCygA4Q6nwGDXSzjIi2RJnpzeYop85/lZqpGvYt5bANp/Tr+TQ7HQFi+UgVVJ7eW06uPx3QngYG5NBqCOhKYWbzOBcPrG6ax/0xP58sABuUmpLiOvdu3ccapXF8Ieu7MkAQYbfGJNMvOODWi2l/vb+/kZrrIWYxxOvjs5I38=
Message-ID: <ed10ee420805022355j4e783fa1qce38d37ab8c4841f@mail.gmail.com>
Date: Fri, 2 May 2008 23:55:03 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: cross-compiling on OS X, make menuconfig fails
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, "Timur Tabi" <timur@freescale.com>,
       "Tony Breeds" <tony@bakeyournoodle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080429180601.GA19652@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <481529B6.6030802@freescale.com>
	 <20080428015151.GW20457@bakeyournoodle.com>
	 <481739BF.8010305@freescale.com>
	 <20080429164535.GB18018@uranus.ravnborg.org>
	 <20080429172057.GN5882@ZenIV.linux.org.uk>
	 <20080429180601.GA19652@uranus.ravnborg.org>
X-Google-Sender-Auth: ee3d35fc6aecdb25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/08, Sam Ravnborg <sam@ravnborg.org> wrote:
> >
>  > Good grief, folks...
>
>  Thanks Al.
>  I've queued up the following patch.
>
>         Sam
>
>  commit c99cc32e0d92f5fdbdd39a7f42cfff869062fff5
>  Author: Sam Ravnborg <sam@uranus.ravnborg.org>
>  Date:   Tue Apr 29 20:02:44 2008 +0200
>
>     kconfig: made check-lxdialog more portable
>
>     OS-X shell did not like 'echo -e' so implement
>     suggestion from Al Viro to use a more portable construct.
>
>     Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
>     Cc: Al Viro <viro@ZenIV.linux.org.uk>
>
>  diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
>  index 62e1e02..5552154 100644
>  --- a/scripts/kconfig/lxdialog/check-lxdialog.sh
>  +++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
>  @@ -36,8 +36,10 @@ trap "rm -f $tmp" 0 1 2 3 15
>
>   # Check if we can link to ncurses
>   check() {
>  -       echo -e " #include CURSES_LOC \n main() {}" |
>  -           $cc -xc - -o $tmp 2> /dev/null
>  +        $cc -xc - -o $tmp 2>/dev/null <<'EOF'
>
> +#include CURSES_LOC
>  +main() {}
>  +EOF
>
>         if [ $? != 0 ]; then
>             echo " *** Unable to find the ncurses libraries or the"       1>&2
>             echo " *** required header files."                            1>&2

This looks O.K.  As a note, whatever behavior is being described here
is system dependent, because on my installation of that other OS, `echo -e'
works fine whether it is invoked as /bin/bash or /bin/sh which appears to be
a strict copy of /bin/bash.

$ uname -v
Darwin Kernel Version 8.11.1: Wed Oct 10 18:23:28 PDT 2007;
root:xnu792.25.20~1/RELEASE_I386

Reviewed-by: SL Baur <steve@xemacs.org>

-sb
