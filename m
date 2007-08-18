Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbXHROaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbXHROaK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 10:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbXHRO3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 10:29:55 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:34343 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbXHRO3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 10:29:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=INVSZwHkfsHXoR3/ZvQyJCy5nStMI6hkYBN9jFfXeaEe1kJ+BqWtKnDVdiKTfCnk+xMJBWP6OQzXKz9JRqWhtV4OzbbVfKvUa4cFbGpV+uHFtd3YVN5LEPBX23dR/W1Q1RFlgLgyPPlQGFsKc8YkXA2tWxH6fU8yl7i1x5eNuYE=
Message-ID: <88dfed9d0708180729s1837b56brf81e905045039561@mail.gmail.com>
Date: Sat, 18 Aug 2007 22:29:54 +0800
From: hufey <hufeyy@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: strange probe order issue after platform_add_devices()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I am facing a very strange issue about device probe order.
I have a piece of code to support network interface card for an embedded box.

It likes following:

...
static struct platform_device *custom_devices[] __initdata = {
          &a_device,
          &b_device,
          &c_device,
};

static int __init device_init()
{
           return platform_add_devices(custom_devices,
ARRAY_SIZE(custom_devices);
}

subsys_initcall(device_init);

/* end */

This code works good with kernel 2.6.11. After platform_add_devices()
is executed, a_device's probe function will be called first then
b_device's probe function be called.
I merged it to 2.6.17, but strange thing is b_device's probe be called
first always now.
Since b_device probe depends on a_device, so it always fails now.

Does anyone know how to fix it? Or give me the hint about how kernel
decide which device be called to probe in order by what mechanism?

Thanks in advance and best regards,
hufeyy
