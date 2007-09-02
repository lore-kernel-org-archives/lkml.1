Return-Path: <linux-kernel-owner+w=401wt.eu-S965998AbXIBLzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965998AbXIBLzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 07:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965212AbXIBLyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 07:54:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45010 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965178AbXIBLyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 07:54:54 -0400
Date: Sun, 2 Sep 2007 04:54:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: gshan <gshan@alcatel-lucent.com>
Cc: linux-kernel@vger.kernel.org, Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: NFS client show nothing for "ls" command.
Message-Id: <20070902045410.54738a77.akpm@linux-foundation.org>
In-Reply-To: <46C528D4.9010904@alcatel-lucent.com>
References: <46C528D4.9010904@alcatel-lucent.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 17 Aug 2007 12:49:24 +0800 gshan <gshan@alcatel-lucent.com> wrote:
> Hi All,
> 
> Recently, I got a funny problem that my NFS client can't show some of 
> mounted directories. These directories that can't be showed by "ls" 
> command have great deals of files.
> 
> For example. I have a directory on NFS server log and there are 69 
> files. I can't show it's child files through NFS.
> 
> ---On NFS server---
> bash-2.05b# ls
> 1   13  17  20  24  28  31  35  39  42  46  5   53  57  60  64  68  9
> 10  14  18  21  25  29  32  36  4   43  47  50  54  58  61  65  69
> 11  15  19  22  26  3   33  37  40  44  48  51  55  59  62  66  7
> 12  16  2   23  27  30  34  38  41  45  49  52  56  6   63  67  8
> 
> ---On NFS client---
> # ls
> #
> 
> After I delete one file from NFS server side, everything becomes OK.
> 
> ---On NFS server---
> bash-2.05b# rm 69
> bash-2.05b# ls
> 1   13  17  20  24  28  31  35  39  42  46  5   53  57  60  64  68
> 10  14  18  21  25  29  32  36  4   43  47  50  54  58  61  65  7
> 11  15  19  22  26  3   33  37  40  44  48  51  55  59  62  66  8
> 12  16  2   23  27  30  34  38  41  45  49  52  56  6   63  67  9
> 
> ---On NFS client---
> # ls
> 1   13  17  20  24  28  31  35  39  42  46  5   53  57  60  64  68
> 10  14  18  21  25  29  32  36  4   43  47  50  54  58  61  65  7
> 11  15  19  22  26  3   33  37  40  44  48  51  55  59  62  66  8
> 12  16  2   23  27  30  34  38  41  45  49  52  56  6   63  67  9
> #
> 
> I also scrapped the packets through ethereal and saw that packet sent at 
> case 1) isn't valid. It only has 3 fileds: ., .. and last. I suppose the 
> problem came from NFS server side because we can't received valid NFS 
> packet for such directories with plenty of files. Anybody knew what's 
> the root cause?
> 

what kernel are you running?
