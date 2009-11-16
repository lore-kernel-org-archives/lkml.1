Return-Path: <linux-kernel-owner+w=401wt.eu-S1753192AbZKPNkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbZKPNkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 08:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbZKPNkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 08:40:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbZKPNkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 08:40:07 -0500
Message-ID: <4B01561A.4090109@redhat.com>
Date: Mon, 16 Nov 2009 08:39:38 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, bhavna.sarathy@amd.com,
       jbarnes@virtuousgeek.org, andreas.herrmann3@amd.com
Subject: Re: [PATCH]: AMD Northbridge: Verify NB's node is online
References: <20091112180933.12532.98685.sendpatchset@prarit.bos.redhat.com> <20091114005800.GB17512@elte.hu>
In-Reply-To: <20091114005800.GB17512@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>
>> Hardware maybe programmed incorrectly and return a bogus node ID.  
>> Check to see if the node is actually online before setting the numa 
>> node for an AMD northbridge in quirk_amd_nb_node().
>>     
>
> Hm, could you stick a printk in there, what precise node ID does the 
> hardware return?
>
>   

Ingo, yup -- I put in a printk and commented out the set_dev_node() call 
when debugging this
and got this output:

quirk_amd_nb_node: current numa_node = 0x0, would set to val & 7 = 0x0
quirk_amd_nb_node: current numa_node = 0x0, would set to val & 7 = 0x1
quirk_amd_nb_node: current numa_node = 0x0, would set to val & 7 = 0x2
quirk_amd_nb_node: current numa_node = 0x0, would set to val & 7 = 0x3

The issue appears to be that the HW has set val to a valid value, 
however, the system is only configured for a single node -- 0.

I realize that I'm working around broken HW ... but I think that a 
quirk, quirk_amd_nb_node(), should at least keep systems booting ...

P.

