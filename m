Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbZKAXSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbZKAXSy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 18:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbZKAXSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 18:18:53 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:63170 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZKAXSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 18:18:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=wyCS3hEK4Oskb89lI1EEUfavWBbnrVHgWLkDK2TrgX/q3UQYEWzXG4dhUA/15IAKhT
         a9jh9N6o8yvSrP8YZGrIKwFie9CEBz8T5Df5GgQLzWwsE2bZlB5k9+0YLkim/kkkUBQv
         WB+qnYRppHjVTP1zNFmfVx1qK9pQQmykVX6Rc=
Date: Mon, 2 Nov 2009 00:18:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>
Cc: laijs@cn.fujitsu.com, mingo@elte.hu, davem@davemloft.net,
       akpm@linux-foundation.org, harvey.harrison@gmail.com,
       linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vsprintf: reduce code size, clean up
Message-ID: <20091101231857.GD5263@nowhere>
References: <b8bf37780911010901i3426f143ve394ae569be74ec1@mail.gmail.com> <20091101224547.GB5263@nowhere> <b8bf37780911011500o741bef51sf8a057e2cedcf22c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8bf37780911011500o741bef51sf8a057e2cedcf22c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 01, 2009 at 09:00:48PM -0200, André Goddard Rosa wrote:
> Hi, Frederic!
> 
> On Sun, Nov 1, 2009 at 8:45 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > On Sun, Nov 01, 2009 at 03:01:40PM -0200, André Goddard Rosa wrote:
> >> +static char null[] = "(null)";
> >> +
> >
> >
> > This should be static const.
> > Also, may be chose a better name, as "null" is too much
> > generic and somehow collide with NULL.
> >
> > null_str ?
> >
> 
> If I make it a "static const" it's necessary to cast it in two places
> to "char *" and code size goes up
> 
> lib/vsprintf.c: In function ‘string’:
> lib/vsprintf.c:556: warning: assignment discards qualifiers from
> pointer target type
> lib/vsprintf.c: In function ‘pointer’:
> lib/vsprintf.c:828: warning: passing argument 3 of ‘string’ discards
> qualifiers from pointer target type
> lib/vsprintf.c:551: note: expected ‘char *’ but argument is of type
> ‘const char *’
> 
>    text    data     bss     dec     hex filename
>  15383       7       8   15398    3c26 lib/vsprintf.o-static-before
>  15431       0       8   15439    3c4f lib/vsprintf.o-static-const-after
> 
> as it moves the variable from data section to code section. Is this
> the preferred method?
> 


Hm, that:

static const char *null = "(null)";

is supposed to go to .rodata

Anyway, yeah better make it a const. When it's used, the variable
is not changed.

save_str in vbin_printf() is already a const char.
The "s" parameter in string() can be safely turned into const.

 
> Thanks for reviewing! I'll fix the other points per your suggestions
> and post back.
> 
> With regards,
> André


Thanks.

