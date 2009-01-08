Return-Path: <linux-kernel-owner+w=401wt.eu-S1763970AbZAHXH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763970AbZAHXH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 18:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760021AbZAHXHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 18:07:12 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:12672 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591AbZAHXHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 18:07:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=v5qBo1KVusVmd4K91lqSeyGfekqp7Wj9RhPbidLWVOVYHqSEb6DqWZ262KbQKFe9bb
         li5ozoqfixCEooF/J+i8NPhYoSLvtjTt3i6NpdfgyhQrSBsWZmaTCSxkQ390EsXqaYIM
         ZseC+3274qg6yyah5f2HsstEIPXj+i3HkAVEo=
Message-ID: <c384c5ea0901081507v5d186eai5ec71d56b4c7a972@mail.gmail.com>
Date: Fri, 9 Jan 2009 00:07:09 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Florian Fainelli" <florian@openwrt.org>
Subject: Re: FPGA programming driver architecture
Cc: "Thiago Galesi" <thiagogalesi@gmail.com>,
       "Hugo Villeneuve" <hugo@hugovil.com>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
In-Reply-To: <200901082357.24432.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20081212150314.6ea24996.hugo@hugovil.com>
	 <82ecf08e0901081414u15af3c2dy9c88a242db024dc7@mail.gmail.com>
	 <c384c5ea0901081447i5ad807b3yb0ec3adebeaa46a0@mail.gmail.com>
	 <200901082357.24432.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 8, 2009 at 11:57 PM, Florian Fainelli <florian@openwrt.org> wrote:
> Le Thursday 08 January 2009 23:47:58 Leon Woestenberg, vous avez écrit :

>> The programming back end should be generic enough so that it can use
>> other subsystems.
>>
> That's the idea behind using request_firmware, which provides you with both a
> pointer to the data and the size of the blob.

I know, that's what I would call the front-end (near userspace).

I meant the low-level back-end (towards hardware):

> - fpgaload-core which contains all the code that can be shared
> between the drivers like requesting firmware, providing sysfs
> attributes,
> - fpgaload-spi would handle the low-level SPI connection
> - fpgaload-par would handle the low-level parallel connection
>
> fpgaload-ser and par would register with fpgaload-core and they could
> register a fpga loading callback which is low-level specific for
> instance.

My $0.02 was:

Those callbacks should also be able to accept chunks of data
(preferably in the same way using ptr/len).


Regards,
-- 
Leon
