Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbYIZH3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbYIZH3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 03:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYIZH3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 03:29:04 -0400
Received: from web50603.mail.re2.yahoo.com ([206.190.38.90]:41248 "HELO
	web50603.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753072AbYIZH3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 03:29:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=B7mO2PuTOAT9reQ8oRpb7Ipwru882KFTdgz5KTZkT8u6Z6D1S8MbTz7eR6GD9ogohwdKEClIk8vDFhoPPzcXXC5T467zduZNHHtgQdBMnbJ7vkTxgTdO5Fz6uRDx0P1HGEWGe1XgPD6b29XuPrPUVVoeR1d5pzvGqo/G5zbMwtU=;
X-YMail-OSG: m6udmJ8VM1koFOBQfXsBfHnhUTwZ26aX4wddwtPo9A501jSwqM0xgBLILA81qyS.gjFNN4zNpmS0CPVPi71V1CQQH28ZPFMDVJnoFAx1vCaq0KvM8zygwGpfPraFGs4HfFhucvu1kZDDlf_V4KL22Sb5vE73
X-Mailer: YahooMailWebService/0.7.218.2
Date: Fri, 26 Sep 2008 00:29:01 -0700 (PDT)
From: marty <martyleisner@yahoo.com>
Subject: disk IO directly from PCI memory to block device sectors
To: linux-kernel@vger.kernel.org
Cc: martin.leisner@xerox.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <247018.46515.qm@web50603.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We  have a large ram area on a PCI board (think of a custom framebuffer
type application).  We're using 2.6.20.

We have the PCI ram mapped into kernel space, and knew the physical addresses.

We have a raw partition on the block device which we reserve for this.

We want to be able to stick the contents of selected portion of PCI ram onto a block device (disk).  Past incarnations modified the disk driver, and developed a special API so the custom driver  constructed scatter/gather lists and fed it to the driver (bypassing the elevator algorithm, to execute
as the "next request".

What I'm looking is for a more generic/driver independent way of sticking
contents of PCI ram onto a disk.

Is offset + length of each bio_vec < pagesize?

What's the best way to do this (much of my data is already in physically
contiguous memory [and mapped into virtual memory)). 

Any good examples to look at?

marty


      
