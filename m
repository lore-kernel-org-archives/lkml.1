Return-Path: <linux-kernel-owner+w=401wt.eu-S1764411AbYFFGWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764411AbYFFGWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 02:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYFFGV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 02:21:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:29770 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYFFGVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 02:21:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fsl28XN2f/6oSVf6hPMQGc5cO4B3KDwpFrGgXCDDeRShz5caq1HXwQIhaLf6zSYohP
         ajc1wjoRgPFLulPWshLPQOEfd81pkaqMwiM2kT3kRMk6zt0bhyKqYQCeBfh4Tf/cTzLd
         zbdZxf//FOZ5vmajGEUoJA+RHOnR5+l47FeSQ=
Date: Fri, 6 Jun 2008 10:17:44 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Armin Schindler <armin@melware.de>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn divas: fix proc creation
Message-ID: <20080606061744.GB4977@martell.zuzino.mipt.ru>
References: <20080530233445.GB7358@martell.zuzino.mipt.ru> <alpine.DEB.0.99.0806051221380.30590@k10.melware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99.0806051221380.30590@k10.melware.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2008 at 12:25:06PM +0200, Armin Schindler wrote:
> On Sat, 31 May 2008, Alexey Dobriyan wrote:
>> 1. creating proc entry and not saving pointer to PDE and checking it
>>   is not going to work.
>
> I don't know where you found this. I have look even in older versions, but
> the pointer divas_proc_entry is set by proc_create(). The patch to
> divasproc.c is wrong, it exists from the beginning of the driver.
> (2.6.25.4 doesn't contain the bug you describe).

Check mainline kernel, namely, 2.6.26-rc5.

>> --- a/drivers/isdn/hardware/eicon/divasproc.c
>> +++ b/drivers/isdn/hardware/eicon/divasproc.c
>> @@ -125,8 +125,8 @@ static const struct file_operations divas_fops = {
>>
>> int create_divas_proc(void)
>> {
>> -	proc_create(divas_proc_name, S_IFREG | S_IRUGO, proc_net_eicon,
>> -		    &divas_fops);
>> +	divas_proc_entry = proc_create(divas_proc_name, S_IFREG | S_IRUGO,
>> +					proc_net_eicon, &divas_fops);
>> 	if (!divas_proc_entry)
>> 		return (0);

