Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbXFTVYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbXFTVYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 17:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbXFTVYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 17:24:35 -0400
Received: from terminus.zytor.com ([192.83.249.54]:46447 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbXFTVYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 17:24:33 -0400
Message-ID: <46799A31.10301@zytor.com>
Date: Wed, 20 Jun 2007 14:20:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>, Ram Pai <linuxram@us.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com> <20070620210343.GQ21478@ftp.linux.org.uk>
In-Reply-To: <20070620210343.GQ21478@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Wed, Jun 20, 2007 at 01:57:33PM -0700, H. Peter Anvin wrote:
>> ... or, alternatively, add a subfield to the first field (which would
>> entail escaping whatever separator we choose):
>>
>> /dev/md6 /export ext3 rw,data=ordered 0 0
>> /dev/md6:/users/foo /home/foo ext3 rw,data=ordered 0 0
>> /dev/md6:/users/bar /home/bar ext3 rw,data=ordered 0 0
> 
> Hell, no.  The first field is in principle impossible to parse unless
> you know the fs type.
> 
> How about making a new file with sane format?  From the very
> beginning.  E.g. mountpoint + ID + relative path + type + options,
> where ID uniquely identifies superblock (e.g. numeric st_dev)
> and backing device (if any) is sitting among the options...

Okay, I see there has been some discussion on this earlier, based on a
proposal by Ram Pai, so it pretty much comes down to redesigning this
right.  I see some issues with his proposal (device numbers exported to
userspace in text form should be separated into major:minor form, for
one thing.)  I know the util-linux-ng people have also had issues with
/proc/mounts that they would like resolved in order to finally nuke
/etc/mtab.

Is Ram still working on this?  I'd like to help make this happen so we
can be done with it.

	-hpa



