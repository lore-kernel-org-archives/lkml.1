Return-Path: <linux-kernel-owner+w=401wt.eu-S1763048AbYBTGAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763048AbYBTGAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:00:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYBTGAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:00:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40496 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYBTGAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:00:03 -0500
Date: Tue, 19 Feb 2008 21:53:28 -0800
From: Greg KH <greg@kroah.com>
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Li Zefan <lizf@cn.fujitsu.com>,
       akpm@osdl.org, "Andrew G. Morgan" <morgan@kernel.org>,
       jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, adobriyan@gmail.com
Subject: Re: [PATCH] exporting capability code/name pairs (try #6)
Message-ID: <20080220055328.GA32014@kroah.com>
References: <47B4FFE0.3000702@ak.jp.nec.com> <20080215183802.GA3925@sergelap.austin.ibm.com> <20080215185003.GA7495@kroah.com> <47B92FF5.1080301@ak.jp.nec.com> <20080218074056.GA19915@kroah.com> <47B945BA.2060107@ak.jp.nec.com> <20080219161610.GA3344@kroah.com> <47BBAEE3.6040301@ak.jp.nec.com> <20080220050236.GA20181@kroah.com> <47BBBCC8.7070707@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BBBCC8.7070707@ak.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 02:38:16PM +0900, Kohei KaiGai wrote:
> Greg KH wrote:
>> On Wed, Feb 20, 2008 at 01:38:59PM +0900, Kohei KaiGai wrote:
>>>>> If we can have a private member in kobj_attribute, we can found the 
>>> content
>>>>> to be returned in a single step.
>>>> Ok, again, just send me a patch that adds this functionality and we will
>>>> be very glad to consider it.
>>> [1/2] Add a private data field within kobj_attribute structure.
>>>
>>> This patch add a private data field, declared as void *, within 
>>> kobj_attribute
>>> structure. Anyone wants to use sysfs can store their private data to 
>>> refer at
>>> _show() and _store() method.
>>> It enables to share a single method function with several similar 
>>> entries,
>>> like ones to export the list of capabilities the running kernel 
>>> supported.
>> But your patch 2/2 doesn't use this interface, why not?
>
> Really?
> The following two _show() methods shared by every capabilities refer
> the private member of kobj_attribute.
>
> | +static ssize_t capability_name_show(struct kobject *kobj,
> | +                    struct kobj_attribute *attr,
> | +                    char *buffer)
> | +{
> | +    /* It returns numerical representation of capability. */
> | +    return scnprintf(buffer, PAGE_SIZE, "%d\n", (int) attr->data);
> | +}
> | +
> | +static ssize_t capability_code_show(struct kobject *kobj,
> | +                    struct kobj_attribute *attr,
> | +                    char *buffer)
> | +{
> | +    /* It returns symbolic representation of capability. */
> | +    return scnprintf(buffer, PAGE_SIZE, "%s\n", (char *) attr->data);
> | +}

Ah, sorry, missed that.  I also missed where this was set up as well :(

thanks,

greg k-h
