Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbZCaJBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbZCaJBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 05:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbZCaJAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 05:00:44 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:13418 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754173AbZCaJAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 05:00:42 -0400
Message-ID: <49D1DB42.3020903@panasas.com>
Date: Tue, 31 Mar 2009 11:58:42 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/8] exofs: file and file_inode operations
References: <49C1331D.1080805@panasas.com>	<1237399127-29206-1-git-send-email-bharrosh@panasas.com> <20090331010417.43deb1e7.akpm@linux-foundation.org>
In-Reply-To: <20090331010417.43deb1e7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2009 09:00:39.0151 (UTC) FILETIME=[29A89FF0:01C9B1DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2009 11:04 AM, Andrew Morton wrote:
> On Wed, 18 Mar 2009 19:58:47 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> implementation of the file_operations and inode_operations for
>> regular data files.
>>
>> Most file_operations are generic vfs implementations except:
>> - exofs_truncate will truncate the OSD object as well
>> - Generic file_fsync is not good for none_bd devices so open code it
>> - The default for .flush in Linux is todo nothing so call exofs_fsync
>>   on the file.
>>
>>
>> ...
>>
>> +static int exofs_file_fsync(struct file *filp, struct dentry *dentry,
>> +			    int datasync)
>> +{
>> +	int ret1, ret2;
>> +	struct address_space *mapping = filp->f_mapping;
>> +
>> +	ret1 = filemap_write_and_wait(mapping);
>> +	ret2 = file_fsync(filp, dentry, datasync);
>> +
>> +	return ret1 ? ret1 : ret2;
>> +}
> 
> It might be better to abort if filemap_write_and_wait() failed.  if the
> hardware is bad, these things can take a looooong time retrying and
> timing out.  There's no point in doubling the delay.
> 
>> ...
>>
> 

OK I got confused by existing code, good point
Boaz
