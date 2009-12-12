Return-Path: <linux-kernel-owner+w=401wt.eu-S1761415AbZLLKIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761415AbZLLKIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 05:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbZLLKIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 05:08:06 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47116 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbZLLKIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 05:08:05 -0500
MIME-Version: 1.0
In-Reply-To: <1257460103.2126.0.camel@yio.site>
References: <1257460103.2126.0.camel@yio.site>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 12 Dec 2009 11:07:54 +0100
Message-ID: <ac3eb2510912120207r528229f6uf8bd0535a6ce76a@mail.gmail.com>
Subject: Re: get_sb_single() - do not pass options twice
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 5, 2009 at 23:28, Kay Sievers <kay.sievers@vrfy.org> wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: vfs: get_sb_single() - do not pass options twice
>
> Filesystem code usually destroys the option buffer while
> parsing it, which leads to errors when the same buffer is
> passed twice. In case we fill a new superblock with the
> options, do not pass the options again to the remount()
> call.

Ping! Can someone please have a look and comment on that?
Something like this will now be needed for 2.6.33 to silent a warning.

Thanks,
Kay

> Cc: Greg KH <greg@kroah.com>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> ---
>  fs/super.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -900,6 +900,8 @@ int get_sb_single(struct file_system_typ
>                        deactivate_locked_super(s);
>                        return error;
>                }
> +               /* options usually get mangled and can only be parsed once */
> +               data = NULL;
>                s->s_flags |= MS_ACTIVE;
>        }
>        do_remount_sb(s, flags, data, 0);
