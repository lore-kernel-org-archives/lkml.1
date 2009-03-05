Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZCEI5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZCEI5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 03:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZCEI5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 03:57:32 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:20100 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbZCEI5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 03:57:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NDBg8loIULv/0WUtpeOMXghoN18P8gNCS5KZuKCkADMr/Akg2dRQfIpnXDWUxzf+XB
         KBus/6rIJa06FFGjMOk9lT3uB5r4PVQvctyozoLWy2jYAUZEsebcON4zqlOdISQ/dRH5
         f/4w9AG4Jxlv8o3jEoZTdA0jCL/WwDhPMc+f8=
Date: Thu, 5 Mar 2009 16:57:41 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/1] unifdef.c change "getline" to "get_line" to avoid
	C library confusion.
Message-ID: <20090305085741.GG1606@hack.private>
References: <dd18b0c30903042141k1adc0f6cj4bc286cfa29f475c@mail.gmail.com> <20090305060436.GA5359@nowhere> <dd18b0c30903042351oae6fafck255d6b1058c83f1f@mail.gmail.com> <dd18b0c30903050046v4fc9eff3h99734406112ec0f1@mail.gmail.com> <dd18b0c30903050049g68073bcamce13b9a2605372ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30903050049g68073bcamce13b9a2605372ba@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 12:49:49AM -0800, Justin Mattock wrote:
>From: Justin P. Mattock <justinmattock@gmail.com>
>Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
>This fixes an error when compiling the kernel.
>
> CHK     include/linux/version.h
> HOSTCC  scripts/unifdef
>scripts/unifdef.c:209: error: conflicting types for 'getline'
>/usr/include/stdio.h:651: note: previous declaration of 'getline' was here
>make[1]: *** [scripts/unifdef] Error 1
>make: *** [__headers] Error 2
>


Looks good! Thanks. If you need, you can add my

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

And let's Cc Sam:

Cc: Sam Ravnborg <sam@ravnborg.org>


>--
>scripts/unifdef.c  |  3 +++
>1 files changed, 3 insertions(+),0 deletions(-)
>
>---a/scripts/unifdef.c	        2009-03-05 00:07:28.000000000 -0800
>+++b/scripts/unifdef.c	2009-03-05 00:04:56.000000000 -0800
>@@ -206,7 +206,7 @@ static void             done(void);
> static void             error(const char *);
> static int              findsym(const char *);
> static void             flushline(bool);
>-static Linetype         getline(void);
>+static Linetype         get_line(void);
> static Linetype         ifeval(const char **);
> static void             ignoreoff(void);
> static void             ignoreon(void);
>@@ -512,7 +512,7 @@ process(void)
>
> 	for (;;) {
> 		linenum++;
>-		lineval = getline();
>+		lineval = get_line();
> 		trans_table[ifstate[depth]][lineval]();
> 		debug("process %s -> %s depth %d",
> 		    linetype_name[lineval],
>@@ -526,7 +526,7 @@ process(void)
>  * help from skipcomment().
>  */
> static Linetype
>-getline(void)
>+get_line(void)
> {
> 	const char *cp;
> 	int cursym;
>
>
>-- 
>Justin P. Mattock
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Do what you love, f**k the rest! F**k the regulations!
 
