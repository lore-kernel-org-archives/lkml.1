Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbYBIWIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbYBIWIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 17:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbYBIWIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 17:08:47 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:33700 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYBIWIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 17:08:47 -0500
Date: Sat, 9 Feb 2008 23:08:45 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Sectionized printk data
In-Reply-To: <20080204180753.GB16050@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0802092307520.6917@fbirervta.pbzchgretzou.qr>
References: <87zlugsox9.fsf@saeurebad.de> <20080204180753.GB16050@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 4 2008 19:07, Sam Ravnborg wrote:
>> The attached patch allows something along the lines:
>> 
>> int __init some_function(void)
>> {
>>         [...]
>>         pr_init(KERN_WARNING "failure %s in %s\n", ...);
>>         [...]
>> }
>> 
>> Another idea I had was to make printk a macro that figures out the
>> section of the surrounding function and then moves the data
>> automatically when it is a literal, but I couldn't find mechanisms that
>> allow this.  Anyone of you got an idea?
>> 
>> What do you think in general?
>
>What is the rationale behind this?

To drop strings that are only shown once anyway, such as:

static int __init ebtables_init(void)
{
        int ret;

        mutex_lock(&ebt_mutex);
        list_add(&ebt_standard_target.list, &ebt_targets);
        mutex_unlock(&ebt_mutex);
        if ((ret = nf_register_sockopt(&ebt_sockopts)) < 0)
                return ret;

->      printk(KERN_INFO "Ebtables v2.0 registered\n");
        return 0;
}

>If you say "saving memory" then please let us know with specific examples
>in what area these savings will really pay off.
