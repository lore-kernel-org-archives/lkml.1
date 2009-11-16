Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZKPOoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZKPOoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 09:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZKPOoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 09:44:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55085 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625AbZKPOoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 09:44:07 -0500
Date: Mon, 16 Nov 2009 15:44:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, bhavna.sarathy@amd.com,
       jbarnes@virtuousgeek.org, andreas.herrmann3@amd.com
Subject: Re: [PATCH]: AMD Northbridge: Verify NB's node is online
Message-ID: <20091116144402.GA16696@elte.hu>
References: <20091112180933.12532.98685.sendpatchset@prarit.bos.redhat.com>
 <20091114005800.GB17512@elte.hu>
 <4B01561A.4090109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B01561A.4090109@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Prarit Bhargava <prarit@redhat.com> wrote:

> 
> >>
> >>Hardware maybe programmed incorrectly and return a bogus node
> >>ID.  Check to see if the node is actually online before setting
> >>the numa node for an AMD northbridge in quirk_amd_nb_node().
> >
> >Hm, could you stick a printk in there, what precise node ID does
> >the hardware return?
> >
> 
> Ingo, yup -- I put in a printk and commented out the set_dev_node()
> call when debugging this
> and got this output:
> 
> quirk_amd_nb_node: current numa_node = 0x0, would set to val & 7 = 0x0
> quirk_amd_nb_node: current numa_node = 0x0, would set to val & 7 = 0x1
> quirk_amd_nb_node: current numa_node = 0x0, would set to val & 7 = 0x2
> quirk_amd_nb_node: current numa_node = 0x0, would set to val & 7 = 0x3
> 
> The issue appears to be that the HW has set val to a valid value, 
> however, the system is only configured for a single node -- 0.
> 
> I realize that I'm working around broken HW ... but I think that a 
> quirk, quirk_amd_nb_node(), should at least keep systems booting ...

Ok. I cleaned up the patch a bit and added a comment explaining the 
logic - and also expanded the changelog with your new debug data, and 
applied it to tip:x86/urgent. Please check the commit notification email 
whether it's all OK.

Thanks,

	Ingo
