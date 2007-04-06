Return-Path: <linux-kernel-owner+w=401wt.eu-S2992824AbXDFA7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992824AbXDFA7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992834AbXDFA7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:59:35 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:2760 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992824AbXDFA7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:59:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=AN8K8e6gp79xLGZZn4wYF0KFbZaC7UD7TDxbTyl/EhTicGuphVLPhtkj7QZ4umfb1kAVm7wM78MyrcT2Jcwub0bTRg0x1qI4WbH1NgdSNVWT+rMeo4nsZZw18EQglF9M/jMPuOS9ozhEK80B8hHufvqVYWZUioQVsis4QKybY+k=
Message-ID: <46159B29.6030106@gmail.com>
Date: Fri, 06 Apr 2007 08:58:17 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: Li Yu <raise.sail@gmail.com>, yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Jiri Kosina <jkosina@suse.cz>,
       Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
References: <200703051532096508636@gmail.com>	<Pine.LNX.4.64.0704031053140.3808@jikos.suse.cz>	<46145026.3050305@gmail.com> <200704042309.19344.dtor@insightbb.com>
In-Reply-To: <200704042309.19344.dtor@insightbb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
>> +static void hid_bus_release(struct device *dev)
>> +{
>> +}
>> +
>> +struct device hid_bus = {
>> +	.bus_id   = "hidbus0",
>> +	.release  = hid_bus_release
>> +};
>> +
>> +static void hid_dev_release(struct device *dev)
>> +{
>> +}
>> +
>>     
>
> That will for sure raise Greg KH's blood pressure ;)
>   

I know your words now. The entire hid_bus device is useless. The
original code of hid bus is copied from LDD3e. It seem the API had
changed since it pressed. In fact, the new kernel only work silent
without it, or the kref_get() will warn us.

And, I fixed the double hidinput_disconnect() problem last night. It's
reason is not invalid memory access, instead of, it's normal behavior of
hidinput_disconnect(). The resolution is easy, We should move inputs
member to hid_device, not in hid_driver. so if we removed one
hid_device, it do not disconnect all devices which its driver bind, just
only itself.

Now, usbhid works fine.

Good luck.

- Li Yu


