Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbZITKkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbZITKkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 06:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZITKkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 06:40:46 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:49567 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZITKkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 06:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Xlj0vF/Z9Glxgwbq2wCtbK+L8QRM+dgKK02AVxiEttWmlO11qWhOHQREkiuVNbJwgz
         yVZ+H1vB3r0g+u6KzSBtkwQN5cyXlqI+tycenZ7BEI8SAT86rAHXPnTgH7fgGBY94HBc
         ppjv+em523rdEiXiJ+ThsCJCfJegyRwjSU16Y=
MIME-Version: 1.0
In-Reply-To: <1cddc13e-c147-43e0-9b40-5e3f07941b27@e34g2000vbm.googlegroups.com>
References: <dmcHr-ep-7@gated-at.bofh.it>
	 <1cddc13e-c147-43e0-9b40-5e3f07941b27@e34g2000vbm.googlegroups.com>
Date: Sun, 20 Sep 2009 12:40:49 +0200
Message-ID: <a769871e0909200340q7afd8951r21a3a025948a5f53@mail.gmail.com>
Subject: Re: EXT4 RAID read performance
From: wbrana@gmail.com
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 3:47 AM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> On Sep 19, 7:20 pm, wbr...@gmail.com wrote:
>>
>> Ext4:
>> read tree total runs 11 avg 20.47 MB/s (user 0.53s sys 0.74s)
>> read compiled tree total runs 4 avg 32.94 MB/s (user 0.61s sys 1.17s)
>>
>> Reiser3:
>> read tree total runs 11 avg 26.33 MB/s (user 0.54s sys 0.81s)
>> read compiled tree total runs 4 avg 41.82 MB/s (user 0.62s sys 1.36s)
>
> It would be interesting to also compare against BTRFS if on 2.6.30 or
> newer, if you can.
>

BTRFS 2.6.31

mkfs.btrfs -d raid10 -m raid10 /dev/sda7 /dev/sdb7 /dev/sdc7 /dev/sdd7
mount -t btrfs -o noatime /dev/sda7 /mnt/md8

intial create total runs 10 avg 158.85 MB/s (user 0.45s sys 0.93s)
create total runs 14 avg 32.67 MB/s (user 0.44s sys 0.90s)
patch total runs 15 avg 8.91 MB/s (user 0.22s sys 0.84s)
compile total runs 14 avg 61.02 MB/s (user 0.09s sys 0.50s)
clean total runs 10 avg 245.12 MB/s (user 0.02s sys 0.18s)

read tree total runs 11 avg 14.03 MB/s (user 0.48s sys 0.87s)
read compiled tree total runs 4 avg 29.14 MB/s (user 0.54s sys 1.37s)

delete tree total runs 10 avg 9.77 seconds (user 0.28s sys 1.37s)
delete compiled tree total runs 4 avg 11.91 seconds (user 0.31s sys 1.60s)
stat tree total runs 11 avg 4.36 seconds (user 0.25s sys 0.33s)
stat compiled tree total runs 7 avg 5.29 seconds (user 0.29s sys 0.37s)
