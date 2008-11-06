Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbYKFOGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbYKFOGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbYKFOGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:06:38 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:53086 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbYKFOGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:06:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=x9aAnV3AXomp6WNCUMbgvHlUnQPVKBi39CDjMr3Trg9rLyYiXEBBD8RAkpcpw/GsWT
         gh0nTSJgjW+win5OuvbYPTaNVNsjINQSWDK2vUHYdI6Ovww5kk8qqPAaQlDCjQnS4q0G
         sNZoBAOxOR+uqrhAYOCY4qiSAIH38VMv5hLEM=
Message-ID: <3aaafc130811060606p1dfbf12cr8c0dc8cd310d0279@mail.gmail.com>
Date: Thu, 6 Nov 2008 09:06:36 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Paul Mackerras" <paulus@samba.org>
Subject: Re: sparc/staging compile error
Cc: "Greg KH" <greg@kroah.com>, "Stephen Rothwell" <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "William L. Irwin" <wli@holomorphy.com>, sparclinux@vger.kernel.org
In-Reply-To: <18706.51153.342079.586525@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081106163626.2306ad75.sfr@canb.auug.org.au>
	 <20081106063709.GB7728@kroah.com>
	 <18706.51153.342079.586525@cargo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2008 at 5:32 AM, Paul Mackerras <paulus@samba.org> wrote:
> Greg KH writes:
>
>> On Thu, Nov 06, 2008 at 04:36:26PM +1100, Stephen Rothwell wrote:
>> > Hi Greg,
>> >
>> > Today's tree from Linus gets the following error from a sparc
>> > allmodconfig build:
>> >
>> > ERROR: "___f_flush_cache_range" [drivers/staging/poch/poch.ko] undefined!
>>
>> Odd, is flush_cache_range() not allowed on the sparc platform?
>
> I'm curious, what is a driver doing calling flush_cache_range()?
> What does it expect it to do precisely?

It's part of the driver's ioctl. Relevant lines:

static int poch_ioctl(struct inode *inode, struct file *filp,
                      unsigned int cmd, unsigned long arg)
{
/* ---snip---*/
        case POCH_IOC_SYNC_GROUP_FOR_USER:
        case POCH_IOC_SYNC_GROUP_FOR_DEVICE:
                vms = find_vma(current->mm, arg);
                if (!vms)
                        /* Address not mapped. */
                        return -EINVAL;
                if (vms->vm_file != filp)
                        /* Address mapped from different device/file. */
                        return -EINVAL;

                flush_cache_range(vms, arg, arg + channel->group_size);


>
> Paul.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
