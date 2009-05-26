Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbZEZNFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbZEZNFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 09:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbZEZNFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 09:05:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:44293 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbZEZNFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 09:05:34 -0400
Message-ID: <4A1BE904.8080302@kernel.org>
Date: Tue, 26 May 2009 22:05:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-pci@vger.kernel.org, Greg KH <greg@kroah.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, towerlexa@gmx.de
Subject: Who's responsible for configuring CLS on a cardbus device?
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 13:05:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is regarding bko#13257.

 http://bugzilla.kernel.org/show_bug.cgi?id=13257

towerlexa@gmx.de was experiencing very slow transfer rate when using a
cardbus sata_sil SATA controller which is known to be sensitive to
cache line size setting.  The reset default is zero and no one
configured it causing poor performance.

This is solvable by simply setting CLS to the correct value but who's
job is it?  For non-hotplug devices, this is configured by the BIOS
(at least on PC), so for hotplug devices I think falls on the lap of
the PCI code but I'm not sure.  If this is something which the
sata_sil driver should be responsible for, is there an established way
to determine the proper CLS value?

Thanks.

-- 
tejun
