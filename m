Return-Path: <linux-kernel-owner+w=401wt.eu-S1761407AbYHENR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761407AbYHENR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 09:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYHENRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 09:17:19 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:39202 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752684AbYHENRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 09:17:18 -0400
Date: Tue, 05 Aug 2008 22:17:17 +0900 (JST)
Message-Id: <20080805.221717.112609710.ryov@valinux.co.jp>
To: righi.andrea@gmail.com
Cc: s-uchida@ap.jp.nec.com, ngupta@google.com, vtaras@openvz.org,
       dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@sourceware.org
Subject: Re: Too many I/O controller patches
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <48981D3B.2020701@gmail.com>
References: <489748E6.5080106@gmail.com>
	<000901c8f6a5$fe64ba30$fb2e2e90$@jp.nec.com>
	<48981D3B.2020701@gmail.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea, Satoshi and all,

Thanks for giving a chance to discuss.

> Mr. Andrew gave a advice "Should discuss about design more and more"
> to me.
> And, in Containers Mini-summit (and Linux Symposium 2008 in Ottawa),
> Paul said that a necessary to us is to decide a requirement first.
> So, we must discuss requirement and design.

We've implemented dm-ioband and bio-cgroup to meet the following requirements:
    * Assign some bandwidth to each group on the same device.
      A group is a set of processes, which may be a cgroup.
    * Assign some bandwidth to each partition on the same device.
      It can work with the process group based bandwidth control.
        ex) With this feature, you can assign 40% of the bandwidth of a
	    disk to /root and 60% of them to /usr.
    * It can work with virtual machines such as Xen and KVM.
      I/O requests issued from virtual machines have to be controlled.
    * It should work any type of I/O scheduler, including ones which
      will be released in the future.
    * Support multiple devices which share the same bandwidth such as
      raid disks and LVM.   
    * Handle asynchronous I/O requests such as AIO request and delayed 
      write requests.
        - This can be done with bio-cgroup, which uses the page-tracking
	  mechanism the cgroup memory controller has.
    * Control dirty page ratio.
        - This can be done with the cgroup memory controller in the near
	  feature. It would be great that you can also use other features
	  the memory controller is going to have with dm-ioband.
    * Make it easy to enhance.
        - The current implementation of dm-ioband has an interface to
	  add a new policy to control I/O requests. You can easily add
	  I/O throttling policy if you want.
    * Fine grained bandwidth control.
    * Keep I/O throughput.
    * Make it scalable.
    * It should work correctly if the I/O load is quite high,
      even when the io-request queue of a certain disk is overflowed.

> Ryo, do you have other documentation besides the info reported in the
> dm-ioband website?

I don't have any documentation besides in the website.

Thanks,
Ryo Tsuruta
