Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZCEPcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZCEPcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 10:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZCEPcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 10:32:43 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:58344 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbZCEPcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 10:32:42 -0500
Message-ID: <49AFF0D7.8080007@oracle.com>
Date: Thu, 05 Mar 2009 07:33:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] unifdef.c change "getline" to "get_line" to avoid
 C 	library confusion.
References: <dd18b0c30903042141k1adc0f6cj4bc286cfa29f475c@mail.gmail.com>	 <20090305060436.GA5359@nowhere>	 <dd18b0c30903042351oae6fafck255d6b1058c83f1f@mail.gmail.com>	 <dd18b0c30903050046v4fc9eff3h99734406112ec0f1@mail.gmail.com> <dd18b0c30903050049g68073bcamce13b9a2605372ba@mail.gmail.com>
In-Reply-To: <dd18b0c30903050049g68073bcamce13b9a2605372ba@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.49AFF078.00FE:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Justin P. Mattock <justinmattock@gmail.com>
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> This fixes an error when compiling the kernel.

Did you determine why you need this now and other people don't
need it (yet)?  Maybe the rest of us will need it in the future...


>  CHK     include/linux/version.h
>  HOSTCC  scripts/unifdef
> scripts/unifdef.c:209: error: conflicting types for 'getline'
> /usr/include/stdio.h:651: note: previous declaration of 'getline' was here
> make[1]: *** [scripts/unifdef] Error 1
> make: *** [__headers] Error 2
> 
> --
> scripts/unifdef.c  |  3 +++
> 1 files changed, 3 insertions(+),0 deletions(-)
> 
> ---a/scripts/unifdef.c	        2009-03-05 00:07:28.000000000 -0800
> +++b/scripts/unifdef.c	2009-03-05 00:04:56.000000000 -0800
> @@ -206,7 +206,7 @@ static void             done(void);
>  static void             error(const char *);
>  static int              findsym(const char *);
>  static void             flushline(bool);
> -static Linetype         getline(void);
> +static Linetype         get_line(void);
>  static Linetype         ifeval(const char **);
>  static void             ignoreoff(void);
>  static void             ignoreon(void);
> @@ -512,7 +512,7 @@ process(void)
> 
>  	for (;;) {
>  		linenum++;
> -		lineval = getline();
> +		lineval = get_line();
>  		trans_table[ifstate[depth]][lineval]();
>  		debug("process %s -> %s depth %d",
>  		    linetype_name[lineval],
> @@ -526,7 +526,7 @@ process(void)
>   * help from skipcomment().
>   */
>  static Linetype
> -getline(void)
> +get_line(void)
>  {
>  	const char *cp;
>  	int cursym;
> 
> 


-- 
~Randy
