Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbZCWJH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbZCWJH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 05:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZCWJHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 05:07:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:11282 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbZCWJHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 05:07:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sw62mXcSzG3rjmlXKdXZHsX0utKPmLm2O7J0kdVA5gQyxYdUwohXXeJ+w9FsRpO0jg
         6W03z/X99YsKt558ds+a3dQd6JDtzCa3T9Mrh4XIE2jwAfS2uczQNIeY2aE4EyLXzZpM
         muQTZvDo8INGtP3loA5Ro4jXRpODCfDMNEXQQ=
Message-ID: <49C7513D.4080106@gmail.com>
Date: Mon, 23 Mar 2009 11:07:09 +0200
From: roma1390 <roma1390@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090212)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: neilb@suse.de
Subject: Re: raid6 grow "hangs" on 2.6.27 with mounted FS
References: <b410963b0903211329v3c4d787ep2f7a0587bee77789@mail.gmail.com> <18887.6136.84328.602390@notabene.brown> <49C74B4D.2060003@gmail.com>
In-Reply-To: <49C74B4D.2060003@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

roma1390 wrote:
> Neil Brown wrote:
>  > This will only happen on very small arrays that take less than a
>  > couple of seconds for the reshape to complete.  I have a patch for
>  > mdadm which makes it more robust in this situation.  It will be in
>  > future releases.
>  >
>  > Does this explain what is happening to you?
> 
> Yes, thanks. May be if I retest this situation with same kernel and 
> limited recovery bandwith, then may be i can't hit same problem again?

Yes limiting speed also is posible workaround for this problem:

   ...
   echo 512 > /sys/block/md2/md/sync_speed_min
   echo 512 > /sys/block/md2/md/sync_speed_max
   mkfs.ext2 /dev/md2
   mount /dev/md2 -t ext2 /mnt
   mdadm --add /dev/md2  /dev/loop5
   mdadm --grow /dev/md2 --raid-devices=5
   ...

Bigger values (like 10000) doesn't help.

Thanks.

