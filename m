Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbZFVMI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbZFVMI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZFVMIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:08:52 -0400
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:56898 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZFVMIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:08:51 -0400
Message-ID: <4A3F7440.3030603@ahsoftware.de>
Date: Mon, 22 Jun 2009 14:08:32 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b5pre) Gecko/20090513 Fedora/3.0-2.4.b3pre.hg.6a6386c16e98.fc11 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: asynchronous calls an the lack of --wait-for-completion options
 	(e.g. modprobe, losetup, cryptsetup)
References: <4A38F229.70504@ahsoftware.de> <4A3AE162.7040407@gmail.com> <ac3eb2510906201220v7fc1d51ve4a9937a3d73d3d4@mail.gmail.com>
In-Reply-To: <ac3eb2510906201220v7fc1d51ve4a9937a3d73d3d4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.06.2009 21:20, Kay Sievers wrote:
> On Fri, Jun 19, 2009 at 02:52, Robert Hancock<hancockrwd@gmail.com>  wrote:
>> On 06/17/2009 07:39 AM, Alexander Holler wrote:
>
>>> The problem is that when I'm e.g. calling modprobe loop, loop might not
>>> has finished it's initialization, when modprobe returns.
>>
>> It will have. Just that udev won't have received the events and created the
>> device node yet. So the solution would likely be on the udev side..
>
> The brutal method to do this is to call:
>    udevadm settle
> after loading the module. It will block until all currently pending
> events for udev are fully handled.
>
> Recent udevadm versions also have a:
>    --exit-if-exists=<filename>
> option, which will make "settle" stop waiting if a given file exists.

Thanks a lot, I already thought it might be udev, but I haven't known 
about udevadm.

Anyway, I still think, that the creation of the device-node is (seen 
from a user-point) part of the module-initialization or part of the 
operation of the userland-tool (like modprobe, losetup or cryptsetup). 
So in my point of view, they should at least offer an option to wait 
until udev finished that operation and should not rely on the user to 
call udevadm.

But I don't want to extend that discussion. I know this is a complex 
subject where many parts are involved and many people are having 
different views (e.g. at boot time such asynchronous completion is often 
wanted).

It would be nice, if at least the userland-tools would document (e.g. in 
there examples-section), that a call to udevadm is necessary before 
going on and using the (should already created) device-node (at least if 
a stable operation on all systems is needed). The problem is, that it 
heavily depends on the system how long udev needs and it might often 
work without a call to udevadm so many people could miss the need to 
call udevadm.

Kind regards,

Alexander Holler
