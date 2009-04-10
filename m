Return-Path: <linux-kernel-owner+w=401wt.eu-S937535AbZDJP0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937535AbZDJP0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 11:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763852AbZDJPZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 11:25:52 -0400
Received: from fire-ce0.netis.ru ([193.233.48.99]:63173 "EHLO fire.netis.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbZDJPZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 11:25:51 -0400
X-Greylist: delayed 717 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Apr 2009 11:25:51 EDT
Date: Fri, 10 Apr 2009 19:12:35 +0400
From: "Alexander V. Lukyanov" <lav@yar.ru>
To: linux-kernel@vger.kernel.org
Subject: 2.6.29.1 vs 2.6.27.21 ext4 performance problem
Message-ID: <20090410151235.GA9690@proxy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-NETIS-MailScanner-Information: Please contact NETIS Telecom for more information <info@netis.ru> (+7 4852 797797)
X-NETIS-MailScanner-ID: n3AFCZPB004411
X-NETIS-MailScanner: Found to be clean
X-NETIS-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=0,
	required 6, autolearn=disabled)
X-NETIS-MailScanner-From: root@proxy.yar.ru
X-NETIS-MailScanner-To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a server that is busy reading and writing several disks with ext4 fs.
After booting 2.6.29.1 kernel I have noticed significant increase in read rate.
I measure the read rate using a script which reads sysfs byte and access counts
and calculates average per second.

Here is the output of the script from 2.6.29.1 kernel:

sda: read-rate=58932   (r=4163)
sdb: read-rate=2570440 (r=40763)
sdc: read-rate=3320403 (r=52756)
sdd: read-rate=3199639 (r=52885)
SUM: read-rate=9149414 (r=150567)

And this is output from 2.6.27.21:

sda: read-rate=32768   (r=4096)
sdb: read-rate=204800  (r=24576)
sdc: read-rate=204800  (r=22528)
sdd: read-rate=704512  (r=45056)
SUM: read-rate=1146880 (r=96256)

The rate is in bytes per second, "r" is accesses per second.
One can notice that the access rate is similar (the work load on the server is
basically the same), but byte rate is much higher.

I don't yet know what causes this reading increase. Any ideas?

-- 
   Alexander.

