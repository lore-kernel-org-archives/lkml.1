Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbXFUVzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbXFUVzu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbXFUVzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:55:22 -0400
Received: from nn7.de ([85.214.94.156]:39118 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756678AbXFUVzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:55:19 -0400
Subject: Re: [PATCH] hwmon/coretemp: Fix a broken error path - microcode
	update fix
From: Soeren Sonnenburg <kernel@nn7.de>
To: Rudolf Marek <r.marek@assembler.cz>
Cc: lkml <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
In-Reply-To: <467AE640.9090409@assembler.cz>
References: <1182026585.4230.8.camel@localhost>
	 <20070616231745.1b0f7bd9@hyperion.delvare>
	 <1182071803.4815.5.camel@localhost>  <467575BF.1090207@assembler.cz>
	 <1182335403.21563.99.camel@localhost>  <467AE640.9090409@assembler.cz>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Jun 2007 23:55:16 +0200
Message-Id: <1182462916.5118.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-21 at 22:57 +0200, Rudolf Marek wrote:
> Hello Soeren,
> 
> Sorry for the delay.
> 
> I'm ccing all lists maybe some other people are interested. There is known 
> errata AE18 which prevents coretemp from working correctly on some mobile Core 
> processors (family 6 model e). My driver refuses to load and now thanks to 
> soeren will not crash ;) However what to do when no microcode update (no new 
> BIOS) is available?
> 
> Soeren pointed at some T60, T60p BIOS update and luckily, there is a easy way 
> how to extract the microcode update and even convert it into the .txt format as 
> microcode update utility (http://www.urbanmyth.org/microcode/) expects.
> Attached scripts generates the mcode.txt file which may be used by the update 
> utility. Please can you give a try?

great! it works:

sensors excerpt :

coretemp-isa-0000
Adapter: ISA adapter
temp1:       +62°C  (high =  +100°C)                     

coretemp-isa-0001
Adapter: ISA adapter
temp1:       +64°C  (high =  +100°C)

> It seems that there is microcode update for CPUID 06E8 version 0x39 just as my 
> driver is checking. So if your CPUID is 06e8 too you should get the coretemp 
> driver working.

how do I find that out ? I mean sensors seem to work but how do I know
which CPUID+version I have ?

> If so I will post a patch and document the script in documentation directory (or 
> at least some general instructions how to do that)
> 
> Please tell me your stepping:
> cat /proc/cpuinfo  | grep stepping

$ cat /proc/cpuinfo  | grep stepping
stepping        : 8
stepping        : 8

Thank you *very* much!
Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
