Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab0BSVWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 16:22:49 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:47081 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab0BSVWq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 16:22:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Tsue4ZrBUS6LEjosMvgCF9SDAn0wsl4dhD4VsEu9nfstK5oalhCmRj6BFqkDFJ30AC
         RnS3cBfso6kSRcOpX3+v0aw2MgwkTUsoYp06p3D6bjtloQeFdLGZvTQ3BX1hct0dkN8t
         TQ10gWc2MD5N1E2rjsMkrV1NRYVhLuDeAZ3/I=
MIME-Version: 1.0
In-Reply-To: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
References: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
Date: Fri, 19 Feb 2010 13:22:45 -0800
X-Google-Sender-Auth: 6503d3b623927395
Message-ID: <93cdabd21002191322g7ea13d8bk52f1545df913f07@mail.gmail.com>
Subject: Re: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
From: Mike Fedyk <mfedyk@mikefedyk.com>
To: James Cloos <cloos@jhcloos.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
       jfs-discussion@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 13, 2010 at 7:11 PM, James Cloos <cloos@jhcloos.com> wrote:
> Sometime between rc6 and rc7 all filesystem I/O started using 100% CPU,
> usually on the order of 60% sys, 40% user.
>
> I've tried this with each of ext4, jfs and btrfs filesystems.  All show
> the same issue.
>

Are you sure you're not running with any of the debugging options
enabled?  I see the same, but I have debugging enabled (rawhide
kernel).

> Using dd(1) to read from the block specials directly works as well and
> as fast as it always has; only reading or writing to mounted filesystems
> is affected.
>
> Box is 32-bit x86, PentiumIII-M; drives are ide using libata.
>
> If the btrfs fs is mounted, the slowdown is enought to trigger the
> hung_task call trace (120s) on the btrfs-transac process.
>
> But the regression is just as apparent when only jfs and ext4 are mounted.
>
> The only filesystems I've found which avoid the regression are tmpfs and
> devtmpfs.
>
> I didn't have time to write up a report when I noticed this in rc7 but
> had to boot back into rc6 for work.
>
> Some of the commits since rc7 looked like they might have addressed this
> regression, but it persists in rc8.
>
> -JimC
> --
> James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
