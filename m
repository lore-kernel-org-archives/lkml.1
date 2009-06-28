Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbZF1NYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbZF1NYD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 09:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbZF1NXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 09:23:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41391 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbZF1NXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 09:23:53 -0400
Message-ID: <4A476F3F.3090301@redhat.com>
Date: Sun, 28 Jun 2009 16:25:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       davidel@xmailserver.org, rusty@rustcorp.com.au
Subject: Re: [KVM PATCH v5 3/4] KVM: Fix races in irqfd using new	eventfd_kref_get
 interface
References: <20090625132441.26748.641.stgit@dev.haskins.net> <20090625132826.26748.15607.stgit@dev.haskins.net> <20090628110650.GA8061@redhat.com> <4A476714.2000602@novell.com> <20090628131859.GC11866@redhat.com>
In-Reply-To: <20090628131859.GC11866@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2009 04:18 PM, Michael S. Tsirkin wrote:
>
> that could be the case, as we have, for example:
>
> static struct file_operations kvm_vm_fops = {
>          .release        = kvm_vm_release,
>          .unlocked_ioctl = kvm_vm_ioctl,
>          .compat_ioctl   = kvm_vm_ioctl,
>          .mmap           = kvm_vm_mmap,
> };
>
> with no owner field.
>
> Avi, shouldn't we initialize the owner field to prevent
> kvm module from going away while files are open?
>    

We do initialize it:

kvm_chardev_ops.owner = module;
kvm_vm_fops.owner = module;
kvm_vcpu_fops.owner = module;

The reason it's not done through the initializer is that we set the 
owner to the vendor module (e.g. kvm-intel.ko) so that you can't remove 
the vendor module when a guest is running.


-- 
error compiling committee.c: too many arguments to function

