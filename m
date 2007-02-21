Return-Path: <linux-kernel-owner+w=401wt.eu-S1422743AbXBUSMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422743AbXBUSMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422748AbXBUSMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:12:47 -0500
Received: from il.qumranet.com ([82.166.9.18]:54563 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422743AbXBUSMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:12:46 -0500
Message-ID: <45DC8B6E.5050205@qumranet.com>
Date: Wed, 21 Feb 2007 20:11:58 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: kvm-devel <kvm-devel@lists.sourceforge.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/6] KVM userspace interface updates for 2.6.21
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patchset moves the kvm userspace interface from having a 
single fd, to having three types of file descriptors:

- one fd returned by open("/dev/kvm") is used for generic access to the 
kvm driver, for example to get the API version and to create virtual 
machines
- when you create a virtual machine, you get back an fd that can be used 
to control vm-wide aspects, like guest memory configuratio
- when you create a virtual cpu, you get an fd that can be used to 
control the vcpu, for example getting and setting registers, and if 
you're really serious, running the guest

The motivation for this change is twofold:
- prevent having a 'struct inode' and 'struct file' with different file 
operation callbacks
- prevent cacheline bouncing of the 'struct file' when we support guest 
smp (by giving each vcpu its own file structure)

A side effect is that the code becomes somewhat cleaner, due to the vcpu 
number not being passed around and validated.

The change was discussed on kvm-devel some time ago.  Thanks to Arnd 
Bergmann for useful suggestions and to the epoll code for inspiration.

-- 
error compiling committee.c: too many arguments to function

