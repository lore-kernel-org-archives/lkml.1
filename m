Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbYFZHTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbYFZHTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbYFZHTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:19:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:36336 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbYFZHTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:19:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=TKj1ZADt+ftZeubO2APGUY3b1DBA9lDplmwyktL557B96EnIelk+Wf8skOm7UDJYCF
         Q8xydW5aE51P6Am8w2n0GyuKX1eH0vhJFUIE8zPN3VMuod9PsZxwxy63FVJLfD6v0a0g
         0gUY13tuzbTwQQGfK/qnMdKHEBmaTX/JJJrdI=
Message-ID: <ac8af0be0806260019q45fa7285oa0fc79fb02254d28@mail.gmail.com>
Date: Thu, 26 Jun 2008 15:19:15 +0800
From: "Zhao Forrest" <forrest.zhao@gmail.com>
To: vatsa@linux.vnet.ibm.com, mingo@elte.hu, containers@lists.osdl.org
Subject: A question about group CFS scheduling
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi experts,

In Documentation/sched-design-CFS.txt it reads:
Group scheduler tunables:

When CONFIG_FAIR_USER_SCHED is defined, a directory is created in sysfs for
each new user and a "cpu_share" file is added in that directory.
        # cd /sys/kernel/uids
        # cat 512/cpu_share             # Display user 512's CPU share
        1024
        # echo 2048 > 512/cpu_share     # Modify user 512's CPU share
        # cat 512/cpu_share             # Display user 512's CPU share
        2048
        #
CPU bandwidth between two users are divided in the ratio of their CPU shares.
For ex: if you would like user "root" to get twice the bandwidth of user
"guest", then set the cpu_share for both the users such that "root"'s
cpu_share is twice "guest"'s cpu_share.

My question is: how is CPU bandwidth divided between cgroup and
regular processes?
For example,
1 the cpu_share of user "root" is set to 2048
2 the cpu_share of user "guest" is set to 1024
3 there're many processes owned by other users, which don't belong to any cgroup
if the relative CPU bandwidth allocated to cgroup of "root" is 2,
allocated to cgroup of "guest" is 1, then what's the relative CPU
bandwidth allocated to other regular processes? 2 or 1?

Thanks,
Forrest
