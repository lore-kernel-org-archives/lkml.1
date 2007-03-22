Return-Path: <linux-kernel-owner+w=401wt.eu-S965869AbXCVIrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965869AbXCVIrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 04:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965880AbXCVIrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 04:47:36 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:62902 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965869AbXCVIrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 04:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KdTt0lXLhbCmsi9+OBrNx6ZlGmblrKniKuHZ60DF+LQU3h5KTpZkiJFaeyMm8TEFpO/vHRazC1Gpjjxcn9zFYwK+uFtB/0dD7Dt9yt09ulWDJsdkCuqzImaKgnUauu+mFojLW+y9/1DAGsXin/1tXXl0kHz+yRuOdWrpcwJOEMs=
Message-ID: <3ae72650703220147j42db8f79s734d4755c2fa43fd@mail.gmail.com>
Date: Thu, 22 Mar 2007 09:47:34 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Bill Nottingham" <notting@redhat.com>
Subject: Re: new sysfs layout and ethernet device names
Cc: linux-kernel@vger.kernel.org, "Greg KH" <greg@kroah.com>
In-Reply-To: <20070320170102.GA16341@nostromo.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070320170102.GA16341@nostromo.devel.redhat.com>
X-Google-Sender-Auth: a81788ea77a1b4af
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/20/07, Bill Nottingham <notting@redhat.com> wrote:
> I was fiddling with the 'new' (no CONFIG_SYSFS_DEPRECATED) layout
> and ethernet device names, and noticed that the new layout effectively
> restricts the availability of certain device names.
>
> By making a directory for the ethernet device name in the parent
> device, you no longer can use any name that is used in sysfs for
> the parent device type - for PCI devices this would be 'resource0',
> 'power', 'enable', etc. For USB, it would be a different set
> of names that are no longer available.

Yeah, we heard, people want to name their network interfaces "irq". :)

> If you *do* try to use one of these names, the rename will succeed...
> partway. The link in /sys/class/net is renamed, the directory is
> not (as it obviously can't rename on top of whatever is already there.)
> Various networking tools then break in assorted ways due to the
> naming disconnect.
>
> Going back to the deprecated layout makes these names available again -
> it's possible (although not necessarily likely) that the new layout
> will break someone's device configuration if they upgrade kernels,
> even if the rest of their tools are updated for the new layout.

There will be a directory at the bus-device with the name of the
class, that glues together the bus-devices and the class-devices in
the unified tree:
  http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f=driver/driver-core-fix-namespace-issue-with-devices-assigned-to-classes.patch;hb=HEAD

So the network-interface(s) will be in their own directory "net",
below the bus-device, and don't conflict with the existing attributes.

Thanks,
Kay
