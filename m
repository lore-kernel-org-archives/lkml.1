Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbZEOApu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbZEOApu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 20:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZEOApl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 20:45:41 -0400
Received: from dovecot.org ([82.118.211.50]:43820 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbZEOApk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 20:45:40 -0400
Cc: linux-kernel@vger.kernel.org
Message-Id: <605A8D56-81CD-4775-8FCD-58CDB12CBA36@iki.fi>
From: Timo Sirainen <tss@iki.fi>
To: Josef Bacik <josef@toxicpanda.com>
In-Reply-To: <1b7401870905141732v43bd7321g1f0d9721b5e3f761@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: ext3/ext4 directories don't shrink after deleting lots of files
Date: Thu, 14 May 2009 20:45:38 -0400
References: <1242338523.6933.664.camel@timo-desktop> <1b7401870905141732v43bd7321g1f0d9721b5e3f761@mail.gmail.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 14, 2009, at 8:32 PM, Josef Bacik wrote:

> On Thu, May 14, 2009 at 6:02 PM, Timo Sirainen <tss@iki.fi> wrote:
>> I've noticed that if you create e.g. 100k files to a directory and  
>> then
>> delete the files, the directory entry still seems to take a couple of
>> megabytes. Later whenever accessing the (almost empty) directory it  
>> can
>> take a few seconds to load it into cache.
>>
>> Is there a way to shrink the directory somehow without having to  
>> rmdir()
>> it? Would be nice if kernel did it automatically, but I could live  
>> with
>> a manual userspace syscall/tool as well.
>>
>
> fsck -D <device>, when its unmounted of course.

I was rather thinking something that I could run while the system was  
fully operational. Otherwise just moving the files to a temp directory  
+ rmdir() + rename() would have been fine too.

I just tested that xfs, jfs and reiserfs all shrink the directories  
immediately. Is it more difficult to implement for ext* or has no one  
else found this to be a problem?

