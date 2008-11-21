Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYKUGnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYKUGnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 01:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYKUGng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 01:43:36 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:27500 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbYKUGnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 01:43:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JWAtnm9W9SJ9p3sk9/IFXCn167VdDChaXA8y0gxzCnUUE5Jq5SwuNCFYtU8sS+16TZ
         h7jG6ZwKEdJfi2AQWodR2WnGh/09ZIuGVYui2mo9njHsfMUoBrSD/g81m1W9jazWSzC/
         szKSMJKBc9Wb6gQvb/6tGnYN+J30i5VQ41qh0=
Message-ID: <804dabb00811202243x2d8d6070l11b245095d2ebe17@mail.gmail.com>
Date: Fri, 21 Nov 2008 14:43:34 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: A question sort_main_extable()
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081120214717.1a02a9af@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <804dabb00811202142y799fb70dxf89a1fc3514d78b1@mail.gmail.com>
	 <20081120214717.1a02a9af@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Arjan.

On Fri, Nov 21, 2008 at 1:47 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Fri, 21 Nov 2008 13:42:56 +0800
> "Peter Teoh" <htmldeveloper@gmail.com> wrote:
>
>> Inside start_kernel() there is a call to sort_main_extable().
>>
>> void sort_extable(struct exception_table_entry *start,
>>                  struct exception_table_entry *finish)
>> {
>>        sort(start, finish - start, sizeof(struct
>> exception_table_entry), cmp_ex, NULL);
>> }
>>

Sorting is one problem, possibly it is partially pre-ordered.

Another problem is memory usage.   Do you or anyone know the amount of
memory used?   In MS windows, there is an article dedicated to
explaining why bootup is quick - one of the contributing factor is
saving memory for only the necessary stuff.   Exception strings, being
rarely needed to be used, will not be loaded into memory until it is
really necessary.   At kernel compilation time, compiler will
intelligently collate all the strings together, and pushed it right to
the end of the kernel binary, avoiding unnecessary loading.   But then
it is a different architecture - as Windows allow swap-in of kernel
image during kernel runtime, unlike that of Linux Kernel - no swap-in
of kernel image at kernel runtime is allowed.

So I guessed there is no way to avoid loading in these exception
strings, even though it is really not needed......unless these can be
pushed out to a specialized kernel module, and used udevd to
dynamically load the module when needed?   Unless the size of memory
saved is substantial enough (how do you calculate that?), I don't
think it is justifiable to take these heavier path whenever strings
are needed.

-- 
Regards,
Peter Teoh
