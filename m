Return-Path: <linux-kernel-owner+w=401wt.eu-S1759228AbXHQEtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228AbXHQEtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 00:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbXHQEts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 00:49:48 -0400
Received: from ihemail2.lucent.com ([135.245.0.35]:51388 "EHLO
	ihemail2.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbXHQEtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 00:49:47 -0400
Message-ID: <46C528D4.9010904@alcatel-lucent.com>
Date: Fri, 17 Aug 2007 12:49:24 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: NFS client show nothing for "ls" command.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Aug 2007 04:49:28.0046 (UTC) FILETIME=[FE0880E0:01C7E089]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Recently, I got a funny problem that my NFS client can't show some of 
mounted directories. These directories that can't be showed by "ls" 
command have great deals of files.

For example. I have a directory on NFS server log and there are 69 
files. I can't show it's child files through NFS.

---On NFS server---
bash-2.05b# ls
1   13  17  20  24  28  31  35  39  42  46  5   53  57  60  64  68  9
10  14  18  21  25  29  32  36  4   43  47  50  54  58  61  65  69
11  15  19  22  26  3   33  37  40  44  48  51  55  59  62  66  7
12  16  2   23  27  30  34  38  41  45  49  52  56  6   63  67  8

---On NFS client---
# ls
#

After I delete one file from NFS server side, everything becomes OK.

---On NFS server---
bash-2.05b# rm 69
bash-2.05b# ls
1   13  17  20  24  28  31  35  39  42  46  5   53  57  60  64  68
10  14  18  21  25  29  32  36  4   43  47  50  54  58  61  65  7
11  15  19  22  26  3   33  37  40  44  48  51  55  59  62  66  8
12  16  2   23  27  30  34  38  41  45  49  52  56  6   63  67  9

---On NFS client---
# ls
1   13  17  20  24  28  31  35  39  42  46  5   53  57  60  64  68
10  14  18  21  25  29  32  36  4   43  47  50  54  58  61  65  7
11  15  19  22  26  3   33  37  40  44  48  51  55  59  62  66  8
12  16  2   23  27  30  34  38  41  45  49  52  56  6   63  67  9
#

I also scrapped the packets through ethereal and saw that packet sent at 
case 1) isn't valid. It only has 3 fileds: ., .. and last. I suppose the 
problem came from NFS server side because we can't received valid NFS 
packet for such directories with plenty of files. Anybody knew what's 
the root cause?

Thanks,
Gavin
