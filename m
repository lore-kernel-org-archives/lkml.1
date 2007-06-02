Return-Path: <linux-kernel-owner+w=401wt.eu-S1763458AbXFBWPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763458AbXFBWPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 18:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760922AbXFBWPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 18:15:15 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50844
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759659AbXFBWPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 18:15:13 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] V2: O_CLOEXEC for SCM_RIGHTS
Date: Sun, 3 Jun 2007 00:14:50 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
References: <200706022148.l52LmVRx023291@devserv.devel.redhat.com>
In-Reply-To: <200706022148.l52LmVRx023291@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706030014.50305.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 June 2007 23:48:31 Ulrich Drepper wrote:
> Take two: I forgot to change the compat code.  This has now happened.  Only one
> additional line changed.
> 
> Everything else from the first patch remains the same.  I try to avoid clogging
> the list unnecessarily by not resending the test program.
> 
> 
> Signed-off-by: Ulrich Drepper <drepper@redhat.com>
> 
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -855,7 +855,7 @@
>  /*
>   * Find an empty file descriptor entry, and mark it busy.
>   */
> -static int get_unused_fd_flags(int flags)
> +int get_unused_fd_flags(int flags)
>  {
>  	struct files_struct * files = current->files;
>  	int fd, error;
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -73,6 +73,7 @@ extern struct file * FASTCALL(fget_light(unsigned int fd, int *fput_needed));
>  extern void FASTCALL(set_close_on_exec(unsigned int fd, int flag));
>  extern void put_filp(struct file *);
>  extern int get_unused_fd(void);
> +extern int FASTCALL(get_unused_fd_flags(int flags));

If you use FASTCALL macro here, you must use fastcall macro at
the definition above, too.

-- 
Greetings Michael.
