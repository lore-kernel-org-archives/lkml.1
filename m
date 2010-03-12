Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab0CLE4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 23:56:14 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:24774 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab0CLE4N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 23:56:13 -0500
MIME-Version: 1.0
In-Reply-To: <20100312104840.2128fe99.sfr@canb.auug.org.au>
References: <20100311173024.4423.53178.stgit@angua> <20100311173203.4423.8733.stgit@angua> 
	<20100312104840.2128fe99.sfr@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 11 Mar 2010 21:55:52 -0700
X-Google-Sender-Auth: 1bad8577eda0bf9d
Message-ID: <fa686aa41003112055i51bb1d31k6874a20d2a37748a@mail.gmail.com>
Subject: Re: [PATCH 2/3] of/flattree: Make unflatten_device_tree() safe to 
	call from any arch
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: devicetree-discuss@lists.ozlabs.org, benh@kernel.crashing.org,
       davem@davemloft.net, jeremy.kerr@canonical.com, monstr@monstr.eu,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 4:48 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Grant,
>
> On Thu, 11 Mar 2010 10:32:03 -0700 Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>> - If CONFIG_OF_FLATTREE is not set, then make unflatten_device_tree()
>>   an empty #define.
>
> "an empty static inline funtion."
>
>> diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
>> index f0fdd1f..54399f1 100644
>> --- a/include/linux/of_fdt.h
>> +++ b/include/linux/of_fdt.h
>> @@ -99,6 +99,8 @@ extern int early_init_dt_scan_root(unsigned long node, const char *uname,
>>  /* Other Prototypes */
>>  extern void unflatten_device_tree(void);
>>  extern void early_init_devtree(void *);
>> +#else /* CONFIG_OF_FLATTREE */
>> +static inline void define unflatten_device_tree(void) {}
>                      ^^^^^^
> You need to remove that.

Fixed.  Thanks.

g.
