Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211Ab0AYQ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab0AYQ6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 11:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162Ab0AYQ6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 11:58:21 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:39167 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab0AYQ6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 11:58:20 -0500
Message-ID: <6ecc677422be02ef48fe8a00a34b8bd2.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <201001202227.31732.oliver@neukum.org>
References: <201001202047.o0KKlMTr014003@mustang.cs.nmsu.edu>
    <201001202227.31732.oliver@neukum.org>
Date: Mon, 25 Jan 2010 09:49:39 -0700
Subject: Re: [PATCH] hid: Logitech G13 driver 0.0.4
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Oliver Neukum" <oliver@neukum.org>
Cc: linux-kernel@vger.kernel.org, felipe.balbi@nokia.com, pavel@ucw.cz,
       jayakumar.lkml@gmail.com, linux-fbdev@vger.kernel.org,
       krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, linux-input@vger.kernel.org, jkosina@suse.cz,
       dmitry.torokhov@gmail.com
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Mittwoch, 20. Januar 2010 21:47:22 schrieb Rick L. Vinyard Jr.:
>> +static ssize_t g13_name_store(struct device *dev,
>> +                             struct device_attribute *attr,
>> +                             const char *buf, size_t count)
>> +{
>> +       struct g13_data *data = dev_get_drvdata(dev);
>> +       size_t limit = count;
>> +       char *end;
>> +
>> +       spin_lock(&data->lock);
>> +
>> +       if (data->name != NULL) {
>> +               kfree(data->name);
>> +               data->name = NULL;
>> +       }
>> +
>> +       end = strpbrk(buf, "\n\r");
>> +       if (end != NULL)
>> +               limit = end - buf;
>> +
>> +       if (end != buf) {
>> +
>> +               if (limit > 100)
>> +                       limit = 100;
>> +
>> +               data->name = kzalloc(limit+1, GFP_KERNEL);
>
> While you hold a spinlock, memory allocations must be done with
> GFP_ATOMIC.
>

Thanks for catching that one. I'll recheck all the rest of the allocs.



