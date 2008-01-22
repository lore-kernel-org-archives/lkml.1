Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817AbYAVXvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbYAVXvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 18:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYAVXvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 18:51:40 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:44965 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbYAVXvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 18:51:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=cU+wxUJTpdI17PV6hSj1gEEGMV0ftfg+NmBXjrVSWtVMuUI06/zz58tmpvnvu59VstOHEc/WtpncA5CHzGQJeszKuSv6p+ButPWfca5/Oqo2IERRUyLwrPYa0ypl81m1uf4SLfXr3BzNSce+ttmjPAM9EBnpT1I0SXFFhBN3TRw=
Message-ID: <47968183.3050704@gmail.com>
Date: Wed, 23 Jan 2008 08:51:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Matthew Wilcox <matthew@wil.cx>, randy.dunlap@oracle.com,
       daniel.ritz-ml@swissonline.ch, jeff@garzik.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk,
 take #2
References: <1200892437108-git-send-email-htejun@gmail.com> <20080121124821.GH27250@parisc-linux.org> <Pine.LNX.4.64.0801230036250.9183@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801230036250.9183@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jan 21 2008 05:48, Matthew Wilcox wrote:
>> On Mon, Jan 21, 2008 at 02:13:52PM +0900, Tejun Heo wrote:
>>> In a nutshell, printk_header() lets you do the following atomically
>>> (against other messages).
>>>
>>>  code:
>>>   printk(KERN_INFO "ata1.00: ", "line0\nline1\nline2\n");
>>>
>>>  output:
>>>   <6>ata1.00: line0
>>>   <6>         line1
>>>   <6>         line2
>> I think this is a really bad idea.  It's much better to have:
>>
>> <6>ata1.00: line0
>> <6>ata1.00: line1
>> <6>ata1.00: line2
>>
>> That way you can grep for ata1.00 and get all messages relevant to that
>> device.
> 
> Agreed, I too prefer <6>ata1.00 on every line.

What do you think about the second suggestion then?

ata1.00: line0
ata1.00  line1
ata1.00  line2

It allows you to grab for the header && has indication for message
boundaries.

-- 
tejun
