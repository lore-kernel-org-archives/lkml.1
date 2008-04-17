Return-Path: <linux-kernel-owner+w=401wt.eu-S1760770AbYDQMbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770AbYDQMbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 08:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763881AbYDQMaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 08:30:55 -0400
Received: from main.gmane.org ([80.91.229.2]:49111 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763700AbYDQMap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 08:30:45 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Neal Becker <ndbecker2@gmail.com>
Subject: Re: [newb] mmap pci
Date: Thu, 17 Apr 2008 08:30:29 -0400
Message-ID: <fu7ft5$4j4$1@ger.gmane.org>
References: <fu4njh$4aa$1@ger.gmane.org> <20080416065217.22691d34@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 139.85.239.127
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:

> On Wed, 16 Apr 2008 07:23:29 -0400
> Neal Becker <ndbecker2@gmail.com> wrote:
> 
>> We have a device - an FPGA board on PCI bus.  It has a range of
>> internal memory mapped to PCI.  I want to expose this to user via
>> mmap.  Is there some example code someone could point me to?
>> 
>> If this is not the best forum for such questions, what would be a
>> better choice?
> 
> Hi,
> 
> if it's just a PCI bar, you can already memory map it without even writing
> a driver! You can just use the sysfs files for this, for example
> /sys/devices/pci0000:00/0000:00:02.0/resource1
> 
> There's also a way to do this via the /proc representation of the PCI
> device..
> 
> Greetings,
>    Arjan van de Ven
> 
> 

Thanks!  Only problem: seems the mapping is read-only?
This python test code works if prot=mmap.PROT_READ, but I get
permission denied if PROT_READ|PROT_WRITE.

import mmap
import struct

f = open ('/sys/bus/pci/devices/0000:05:0f.0/resource0','rw')
m = mmap.mmap(f.fileno(), 1000000, prot=mmap.PROT_READ)


