Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbYKFRgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbYKFRgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbYKFRgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:36:13 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:12681 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbYKFRgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:36:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HVoPyUAUwKAMZHFTYEu/XBctPGPLkrCL/E3W6cB6uLwOYuMdkWXCcy8fJBD3NI+h7k
         ECg0QwCn/uiSBMIXgGuzRAhbuZQB209pmY8EGKk4Jfft5/IFtwmnWpRXui7jxx5A704+
         RJ6lwYUj7t/4x/CpvOC3bsWi+1mhNDu9zoSrE=
Message-ID: <3aaafc130811060936u371e8b9eyccd0c52693f4c433@mail.gmail.com>
Date: Thu, 6 Nov 2008 12:36:11 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: sparc/staging compile error
Cc: "Paul Mackerras" <paulus@samba.org>, "Greg KH" <greg@kroah.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "William L. Irwin" <wli@holomorphy.com>, vijaykumar@bravegnu.org,
       jayakumar.lkml@gmail.com, sparclinux@vger.kernel.org
In-Reply-To: <20081106173224.GA25767@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081106163626.2306ad75.sfr@canb.auug.org.au>
	 <20081106063709.GB7728@kroah.com>
	 <18706.51153.342079.586525@cargo.ozlabs.ibm.com>
	 <3aaafc130811060606p1dfbf12cr8c0dc8cd310d0279@mail.gmail.com>
	 <20081106173224.GA25767@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 6, 2008 at 12:32 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Nov 06, 2008 at 09:06:36AM -0500, J.R. Mauro wrote:
>> static int poch_ioctl(struct inode *inode, struct file *filp,
>>                       unsigned int cmd, unsigned long arg)
>> {
>> /* ---snip---*/
>>         case POCH_IOC_SYNC_GROUP_FOR_USER:
>>         case POCH_IOC_SYNC_GROUP_FOR_DEVICE:
>>                 vms = find_vma(current->mm, arg);
>>                 if (!vms)
>>                         /* Address not mapped. */
>>                         return -EINVAL;
>>                 if (vms->vm_file != filp)
>>                         /* Address mapped from different device/file. */
>>                         return -EINVAL;
>>
>>                 flush_cache_range(vms, arg, arg + channel->group_size);
>
> This doesn't look like something a driver should ever do.  Could someone
> explain what it's trying to do from a high level point of view?
>
>

CC'd driver maintainers mentioned in the README
