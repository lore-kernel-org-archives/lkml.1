Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbXFTWIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbXFTWIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbXFTWIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:08:05 -0400
Received: from terminus.zytor.com ([192.83.249.54]:60162 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbXFTWID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:08:03 -0400
Message-ID: <4679A53B.9090103@zytor.com>
Date: Wed, 20 Jun 2007 15:07:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com> <20070620220551.GX7226@petra.dvoda.cz>
In-Reply-To: <20070620220551.GX7226@petra.dvoda.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karel Zak wrote:
> On Wed, Jun 20, 2007 at 01:57:33PM -0700, H. Peter Anvin wrote:
>> We could add a field to /proc/mounts to add this information:
>>
>> /dev/md6 /export ext3 rw,data=ordered 0 0 /
>> /dev/md6 /home/foo ext3 rw,data=ordered 0 0 /users/foo
>> /dev/md6 /home/bar ext3 rw,data=ordered 0 0 /users/bar
> 
>  I prefer this format. It's compatible with the mount(8) -- the mount
>  ignores extra columns.
> 
>> ... or, alternatively, add a subfield to the first field (which would
>> entail escaping whatever separator we choose):
>>
>> /dev/md6 /export ext3 rw,data=ordered 0 0
>> /dev/md6:/users/foo /home/foo ext3 rw,data=ordered 0 0
>> /dev/md6:/users/bar /home/bar ext3 rw,data=ordered 0 0
> 
>  We needn't a new separator (':') there already is one (' ').
> 
>> I'm personally leaning toward the second option (/dev/md6:/users/foo).
>> Although that might confuse current utilities, those utilities are
>> *already* liable to get confused by the fact that the line doesn't mean
>> what they think it means.
> 
>  Many people use "ln -s /proc/mounts /etc/mtab".
> 

Out of curiosity, and trying to better grok the problem, what would
mount(8) do differently with the second format versus the first?

	-hpa
