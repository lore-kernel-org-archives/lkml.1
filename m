Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab0BDPA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 10:00:57 -0500
Received: from mout.perfora.net ([74.208.4.194]:51105 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab0BDPAz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 10:00:55 -0500
MIME-Version: 1.0
In-Reply-To: <20100204111337.0c474c94@lxorguk.ukuu.org.uk>
References: <f608b67d1002032224r74450689ge416382a1db8e4cf@mail.gmail.com> 
	<20100204111337.0c474c94@lxorguk.ukuu.org.uk>
From: vb@vsbe.com
Date: Thu, 4 Feb 2010 07:00:19 -0800
Message-ID: <f608b67d1002040700t73e58e1dv2aa0c8d781823073@mail.gmail.com>
Subject: Re: associating miscdevice with inode
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX18ghpXrGKwdpTuz+mLjpCc9FoCuLiNQKvx1BvT
 l7gV6lHQmWDNyV0jXjEtm3l4ONgyvWhNTn3BSqxEXRMXc/DSeB
 JPSRvKrLWnCuNK27b9dMw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 4, 2010 at 3:13 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 3 Feb 2010 22:24:46 -0800
> vb@vsbe.com wrote:
>
>> guys,
>>
>> say I have a misc device driver which instantiates several devices.
>> When a file operation on this device is invoked, I need to be able to
>> figure out which device is being accessed. All available information
>> are
>>
>> struct inode and struct file. Is there a way to find the address of
>> the miscdevice structure passed to misc_register() when this device
>> was created?
>
> Not really. If you have a single misc device which each open creates a
> new context of some sort then use filp->private_data to store your own
> cotntext pointer.
>
> Misc doesn't expect people to be registering lots of devices - its for
> one offs and weirdnesses. You could I guess work backwards from
>
>        minor = iminor(inode);
>
> and see which of your miscdevs has c->minor == minor.
>

Alan, thanks a lot for your reply, this is exactly what I was looking for,

cheers,
/vb

> If you have more than a couple of instances being put into misc you
> should probably register an anonymous device major/minor range instead
> and go direct.
>
> Alan
>
