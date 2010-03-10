Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0CJGlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 01:41:36 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:59096 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab0CJGld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 01:41:33 -0500
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 01:41:32 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=geIxCZevRwbZVPeNg+EIfKeDgk4Sq0b/vrYOfMepWkhMK3ogyBJhp0bDukqqg1SH5Y
         y/YerWDxYekQKrCnXHqbKZOFJceqoLKKSbtzB5HfQKu680zav1N7UB8UJeixo5MHITK4
         VhCDYYmU+wBaJSmbvbNAMAdXKK4kuelUkRhgA=
MIME-Version: 1.0
In-Reply-To: <20100310023143.GA20402@cpu18.student.cs>
References: <20100310023143.GA20402@cpu18.student.cs>
Date: Wed, 10 Mar 2010 14:36:21 +0800
Message-ID: <7b6bb4a51003092236k4f5baa1tbb6dcf0b81038310@mail.gmail.com>
Subject: Re: [Regression, bisected] tcpdump broken in 2.6.34-rc1
From: Xiaotian Feng <xtfeng@gmail.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, Jiri Pirko <jpirko@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 10:31 AM, Nick Bowler <nbowler@elliptictech.com> wrote:
> After upgrading to 2.6.34-rc1, tcpdump fails with the following message:
>
>  tcpdump: setsockopt: Invalid argument
>
> The issue is reproducable on two very different machines: one using
> iwlagn and the other using et131x.  Bisection reveals the following and
> reverting the implicated commit resolves the issue.
>
> 914c8ad2d18b62ad1420f518c0cab0b0b90ab308 is the first bad commit
> commit 914c8ad2d18b62ad1420f518c0cab0b0b90ab308
> Author: Jiri Pirko <jpirko@redhat.com>
> Date:   Wed Feb 24 23:57:04 2010 +0000
>

I think this regression has been fixed in today's net pull request.

http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commit;h=1162563f82b434e3099c9e6c1bbdba846d792f0d

>    af_packet: do not accept mc address smaller then dev->addr_len in packet_mc_add()
>
>    There is no point of accepting an address of smaller length than dev->addr_len
>    here. Therefore change this for stonger check.
>
>    Signed-off-by: Jiri Pirko <jpirko@redhat.com>
>    Signed-off-by: David S. Miller <davem@davemloft.net>
>
> :040000 040000 e76af2835c200aea1f3b1268f5e2e7c930ece887 87d5869972605cc130372168f450ee0def0b169b M      net
>
> git bisect start
> # bad: [57d54889cd00db2752994b389ba714138652e60c] Linux 2.6.34-rc1
> git bisect bad 57d54889cd00db2752994b389ba714138652e60c
> # good: [baac35c4155a8aa826c70acee6553368ca5243a2] security: fix error return path in ima_inode_alloc
> git bisect good baac35c4155a8aa826c70acee6553368ca5243a2
> # bad: [47871889c601d8199c51a4086f77eebd77c29b0b] Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
> git bisect bad 47871889c601d8199c51a4086f77eebd77c29b0b
> # good: [e0d272429a34ff143bfa04ee8e29dd4eed2964c7] Merge branch 'tracing-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
> git bisect good e0d272429a34ff143bfa04ee8e29dd4eed2964c7
> # good: [b3b3f04fb587ecb61b5baa6c1c5f0e666fd12d73] tg3: Update driver version to 3.107
> git bisect good b3b3f04fb587ecb61b5baa6c1c5f0e666fd12d73
> # good: [19bc291c99f018bd4f2c38bbf69144086dca903f] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6
> git bisect good 19bc291c99f018bd4f2c38bbf69144086dca903f
> # good: [f66ffdedbf0fc059a92219bb08c1dbcac88f074b] Merge branch 'sched-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
> git bisect good f66ffdedbf0fc059a92219bb08c1dbcac88f074b
> # bad: [46976c042ba1ff59253f2f7a513099175c24794e] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/holtmann/bluetooth-next-2.6
> git bisect bad 46976c042ba1ff59253f2f7a513099175c24794e
> # bad: [b914a250e7b390c713b36a9405a39c4c11abad80] Bluetooth: Convert Marvell driver to use per adapter debugfs
> git bisect bad b914a250e7b390c713b36a9405a39c4c11abad80
> # good: [a4dde3abbf87a495154a876576e1ab34b17b5ef1] cnic: Use union for the status blocks of different devices.
> git bisect good a4dde3abbf87a495154a876576e1ab34b17b5ef1
> # bad: [738b0343e73604750feb107e063c28b3ca36cb84] Revert "ethtool: Add n-tuple string length to drvinfo and return it"
> git bisect bad 738b0343e73604750feb107e063c28b3ca36cb84
> # bad: [e5e26d75f490d7d41f25a4b39ed6db1713beb417] netdev: use list_first_entry macro
> git bisect bad e5e26d75f490d7d41f25a4b39ed6db1713beb417
> # good: [2a3f279034b46204b50408aa2c25ee0882120147] myri10ge: optimize 4k-boundary check when stocking rx pages
> git bisect good 2a3f279034b46204b50408aa2c25ee0882120147
> # bad: [4edb246626be6e031950205c885bdf29fb2ff1eb] rtnetlink: clean up SR-IOV config interface
> git bisect bad 4edb246626be6e031950205c885bdf29fb2ff1eb
> # bad: [914c8ad2d18b62ad1420f518c0cab0b0b90ab308] af_packet: do not accept mc address smaller then dev->addr_len in packet_mc_add()
> git bisect bad 914c8ad2d18b62ad1420f518c0cab0b0b90ab308
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
