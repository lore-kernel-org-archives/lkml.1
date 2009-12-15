Return-Path: <linux-kernel-owner+w=401wt.eu-S1760940AbZLOTGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940AbZLOTGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760930AbZLOTGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:06:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:50945 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760904AbZLOTGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:06:21 -0500
Message-ID: <4B27DDD7.5040301@kernel.org>
Date: Tue, 15 Dec 2009 11:04:55 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       rdreier@cisco.com, Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: kexec boot regression
References: <20091215115052.GA28252@kernel.dk> <4B277AB2.8030107@kernel.org> <20091215121436.GB28252@kernel.dk> <4B2781AC.8020301@kernel.org> <20091215123951.GD28252@kernel.dk> <4B278734.2040704@kernel.org> <20091215141105.GK28252@kernel.dk> <4B27D7E9.4030105@kernel.org> <20091215185941.GO28252@kernel.dk>
In-Reply-To: <20091215185941.GO28252@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Tue, Dec 15 2009, Yinghai Lu wrote:
>> [   13.018720] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
>>
>> [   13.100724] [Firmware Bug]: PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] not reserved in ACPI motherboard resources
> 
> On a "normal" non-kexec boot, I get:
> 
> [   12.173583] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0x80000000-0x8fffffff] (base 0x80000000)
> [   12.184075] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
> [   12.216874] PCI: Using configuration type 1 for base access
> 

can you run following scripts in first kernel?

cd /sys/firmware/memmap
for dir in * ; do
  start=$(cat $dir/start)
  end=$(cat $dir/end)
  type=$(cat $dir/type)
  printf "%016x-%016x (%s)\n" $start $[ $end +1] "$type" >> /tmp/memmap.txt
done

and send out /tmp/memmap.txt

what is your kexec tools version? could be too old?

YH

