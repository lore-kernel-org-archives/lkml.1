Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbYAQTCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbYAQTCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYAQTCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:02:22 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57689 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012AbYAQTCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:02:21 -0500
Date: Thu, 17 Jan 2008 11:01:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       NeilBrown <neilb@suse.de>, mingo@redhat.com, linux-raid@vger.kernel.org
Subject: Re: do_md_run returned -22 [Was: 2.6.24-rc8-mm1]
Message-Id: <20080117110153.f224f24e.akpm@linux-foundation.org>
In-Reply-To: <478F72F2.6000707@gmail.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<478F72F2.6000707@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 16:23:30 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:

> On 01/17/2008 11:35 AM, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/
> 
> still the same md issue (do_md_run returns -22=EINVAL) as in -rc6-mm1 reported 
> by Thorsten here:
> http://lkml.org/lkml/2007/12/27/45

hm, I must have been asleep when that was reported.  Neil, did you see it?

> Is there around any fix for this?

Well, we could bitbucket md-allow-devices-to-be-shared-between-md-arrays.patch

> Having 0.90 raid 0 and 1, commenting this out helps:
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 8633bd4..9b8ecc8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3292,8 +3292,8 @@ static int do_md_run(mddev_t * mddev)
>           * Analyze all RAID superblock(s)
>           */
>          if (!mddev->raid_disks) {
> -               if (!mddev->persistent)
> -                       return -EINVAL;
> +/*             if (!mddev->persistent)
> +                       return -EINVAL;*/
>                  analyze_sbs(mddev);
>          }
> 
> The persistency is marked even in analyze_sbs->validate_super, I guess?
