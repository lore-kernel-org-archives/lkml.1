Return-Path: <linux-kernel-owner+w=401wt.eu-S932380AbZINWY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbZINWY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 18:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932310AbZINWYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 18:24:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932316AbZINWYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 18:24:52 -0400
Date: Mon, 14 Sep 2009 15:24:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: justinmattock@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [mmotm] change "getline" to "get_line" to avoid C
 library  confusion
Message-Id: <20090914152427.71d1fa93.akpm@linux-foundation.org>
In-Reply-To: <d760cf2d0909132059j9852955s429be24aea1722ee@mail.gmail.com>
References: <d760cf2d0909132059j9852955s429be24aea1722ee@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 09:29:30 +0530
Nitin Gupta <ngupta@vflare.org> wrote:

> Reintroduce this change to fix compilation error on mmotm.
> (Original change by Justin P. Mattock)
> 
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> ---
>  scripts/unifdef.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/unifdef.c b/scripts/unifdef.c
> index 552025e..05a31a6 100644
> --- a/scripts/unifdef.c
> +++ b/scripts/unifdef.c
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


I'm all confused again.  This:

commit d15bd1067b1fcb2b7250d22bc0c7c7fea0b759f7
Author:     Justin P. Mattock <justinmattock@gmail.com>
AuthorDate: Sat Mar 7 13:31:29 2009 +0100
Commit:     Sam Ravnborg <sam@ravnborg.org>
CommitDate: Sat Mar 7 13:31:29 2009 +0100

    kbuild: fix C libary confusion in unifdef.c due to getline()

went into mainline months ago and afaict nothing has subsequently
changed in that area?

