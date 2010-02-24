Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab0BXWRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 17:17:35 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:56948 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387Ab0BXWRe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 17:17:34 -0500
MIME-Version: 1.0
In-Reply-To: <20100224214442.GB18437@suse.de>
References: <20100224210514.16289.86611.stgit@angua> <20100224214442.GB18437@suse.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 24 Feb 2010 15:09:24 -0700
X-Google-Sender-Auth: 5bd79f0784e71c51
Message-ID: <fa686aa41002241409x4bcdabfet43e410eb8c480166@mail.gmail.com>
Subject: Re: [RFC] driver-core: Add device node pointer to struct device
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       kay.sievers@vrfy.org, benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 2:44 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Feb 24, 2010 at 02:10:30PM -0700, Grant Likely wrote:
>> Greg and Kay,
>>
>> This is a patch from a larger series of OF related cleanup patches.  This
>> one adds a new 'of_node' member to struct device, conditional upon
>> CONFIG_OF.  The goal is to move of_node out of archdata because all
>> arches using CONFIG_OF need it.
>>
>> Before I commit too much effort down this path, I want to get your
>> feedback.  Do you have any objections to this change to struct device?
>>
>> @@ -414,6 +415,9 @@ struct device {
>>                                            override */
>>       /* arch specific additions */
>>       struct dev_archdata     archdata;
>> +#ifdef CONFIG_OF
>> +     struct device_node      *of_node;
>> +#endif
>
> No objection from me, but do we really need the #ifdef here?

I added the #ifdef because it is complete dead weight when CONFIG_OF
is not set.  However, I'll defer to your preference here on what looks
cleaner w.r.t. maintenance.

>> Full patch follows...
>
> Do you want to take this patch through your tree?  If so, feel free to
> add:
>        Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

I'll take it through my tree.  I've got a lot of related patches that
it should be grouped with, and I'm going to defer it to the 2.6.35
merge window so that it can get some linux-next exposure.

> to the patch.
>
> If not, let me know and I'll take it through my tree.
>
> Glad to see this work coming along, nice job.

Thanks!

Cheers,
g.
