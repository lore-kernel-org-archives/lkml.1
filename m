Return-Path: <linux-kernel-owner+w=401wt.eu-S1761389AbZJIUDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761389AbZJIUDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 16:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761351AbZJIUDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 16:03:32 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:65306 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761336AbZJIUDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 16:03:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=RKt1EgqSi8iqwDVSxSr5HMrfjwHwiQi+tnMnc6Q9brE5Cv5npzcYQHFOyhkRjiZeWs
         Oh8D3dHrNhLM1biyBmMi8ueh1tcl7DWzjnvngn9uwKX6jrKlvxhwuOeMdZvPDLjd4oGA
         QBW6xxO5fqfQ15jACVI+ne7DQ+yWP2605MpFc=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: wrong final bzImage build (regading #14270)
Date: Fri, 9 Oct 2009 22:02:51 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc3-00064-gd2ae972-dirty; KDE/4.3.2; x86_64; ; )
Cc: Michael Tokarev <mjt@tls.msk.ru>, Cyrill Gorcunov <gorcunov@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>
References: <4ACF460E.7000901@msgid.tls.msk.ru> <20091009145825.GE5311@lenovo> <4ACF9184.9040104@msgid.tls.msk.ru>
In-Reply-To: <4ACF9184.9040104@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910092202.51208.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 of October 2009, Michael Tokarev wrote:
> Ok, some more to this.
> 
> It turns out dash's built-in echo command interprets \nnn octal
> sequences by default, and there's no way to turn that off.  So,
> for example, sed-zoffset command from arch/x86/boot/Makefile
> (which includes \1 \2 etc substitutions for sed), when echoed
> in verbose mode (V=1), produces.. interesting characters (with
> ascii code 1 and 2).
> 
> It's not practival to replace V=1's echo with /bin/echo I think.
> 
> So I'd say it's not a bug in the build system after all, but
> a bug in dash.  

It's still a bug in build system if you consider that a /bin/sh is a posix 
shell. posix shells don't support \hex notation (see single unix system 
specification).

I had exactly this problem few weeks ago with pdksh as /bin/sh (and 
bugreported to author of that change). As I workaround I used /bin/echo but 
using printf is more sane/portable.

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
