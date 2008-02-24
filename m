Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbYBXRDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbYBXRDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 12:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbYBXRDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 12:03:07 -0500
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:46018 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYBXRDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 12:03:06 -0500
To: Peter Osterlund <petero2@telia.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack overflow: ide-cd related? dm-related?
References: <87wsovkth5.fsf@hades.wkstn.nix> <87skzipcpw.fsf@hades.wkstn.nix>
	<m363wepa3a.fsf@telia.com>
From: Nix <nix@esperi.org.uk>
Emacs: if it payed rent for disk space, you'd be rich.
Date: Sun, 24 Feb 2008 17:02:26 +0000
In-Reply-To: <m363wepa3a.fsf@telia.com> (Peter Osterlund's message of "Sun, 24 Feb 2008 17:56:09 +0100")
Message-ID: <87oda6p9st.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC--Metrics: hades 1356; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 Feb 2008, Peter Osterlund told this:

> Nix <nix@esperi.org.uk> writes:
>> But while I'd normally blame pktcdvd there's only one pktcdvd function
>> in these tracebacks (pkt_open) and it's not got a significant stack
>> footprint.
>
> Did you verify that with "make checkstack" or just by looking at the
> source code? On my system, pkt_open() consumes 584 bytes because the
> compiler decides to inline lots of functions that would not normally
> be part of long call chains. The following patch fixes that problem on
> my system.

I just looked at the source; I forgot `make checkstack' existed.

On this system:

0xc0263e0f pkt_open [vmlinux]:                          556

which is nearly as bad.

(As an aside, I'm surprised I didn't oops when packet-writing as well:

0xc021270d udf_process_sequence [vmlinux]:              692
0xc020f43d udf_add_entry [vmlinux]:                     628

owch. I guess that's called via a shorter call chain...)


I'll try the patch after this series of backups is done :)

-- 
`The rest is a tale of post and counter-post.' --- Ian Rawlings
                                                   describes USENET
