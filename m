Return-Path: <linux-kernel-owner+w=401wt.eu-S934301AbZIDVXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301AbZIDVXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 17:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934254AbZIDVXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 17:23:32 -0400
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:55124 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934025AbZIDVXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 17:23:32 -0400
Date: Fri, 4 Sep 2009 15:23:16 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland Dreier <rdreier@cisco.com>, tpmdd-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, srajiv@linux.vnet.ibm.com,
       debora@linux.vnet.ibm.com, m.selhorst@sirrix.com, jmorris@namei.org,
       jbeulich@novell.com
Subject: Re: [PATCH] TPM: Fixup pubek sysfs file
Message-ID: <20090904212316.GZ406@obsidianresearch.com>
References: <20090904045231.GW4973@obsidianresearch.com> <adaab1bnvz3.fsf@cisco.com> <20090904140325.c592289a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090904140325.c592289a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 02:03:25PM -0700, Andrew Morton wrote:
> On Thu, 03 Sep 2009 22:02:24 -0700
> Roland Dreier <rdreier@cisco.com> wrote:
> 
> > 
> >  > Algorithm: 00 00 00 01
> >  > Encscheme: 00 03
> >  > Sigscheme: 00 01
> >  > Parameters: 00 00 08 00 00 00 00 02 00 00 00 00
> >  > Modulus length: 256
> > 
> > No argument that this fix is an improvement, but what happened to the
> > "one value per file" rule for sysfs??
> 
> We goofed.  This one snuck through.
> 
> It's one of the reasons why I recommend that people cite examples of
> the sysfs/procfs output in changelogs.  These things are part of the
> kernel ABI and once they go in we cannot change them so we have to get
> them right first time.

Several of the sysfs files in the TPM driver are goofed:

/sys/devices/platform/tpm_tis.0 # cat caps
Manufacturer: 0x57454300
TCG version: 1.2
Firmware version: 2.16

/sys/devices/platform/tpm_tis.0 # cat pcrs 
PCR-00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-01: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-02: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-03: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-04: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-05: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-06: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-07: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-08: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-09: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-11: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-12: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-13: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-14: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-15: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-16: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
PCR-17: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
PCR-18: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
PCR-19: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
PCR-20: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
PCR-21: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
PCR-22: FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
PCR-23: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 

/sys/devices/platform/tpm_tis.0 # cat pubek
Algorithm: 00 00 00 01
Encscheme: 00 03
Sigscheme: 00 01
Parameters: 00 00 08 00 00 00 00 02 00 00 00 00
Modulus length: 256
Modulus: 
AF 6B 30 9B 0D B3 B4 7D 74 35 68 45 8D CA A5 EF 
A8 8A DD 0F D7 84 8E 8D 1F 40 22 92 09 CF 12 C8 
9F 6E 55 57 6A 2C A8 0B 5E 45 C7 5E 3D 56 DA 64 
E6 E1 F7 8C DD 41 92 28 2E 06 41 02 3E 11 7D B2 
C5 46 38 E5 8C 60 D2 96 EE 0C D6 3D F8 99 E3 02 
3A 32 7A 02 C8 31 29 98 28 B9 1B EF 30 A1 A0 45 
A0 C0 05 0E C5 96 95 FD 91 47 0A 35 E0 69 B0 8B 
49 BD B9 F6 5D 25 21 25 79 1B 20 0D C3 C7 1F 87 
5E 5F 41 4B DE 32 DF 55 F3 BD 7F CA D8 7D 3A B4 
D5 0A EF CF 8E 72 20 52 15 FA FB C6 C0 2E C2 AB 
C6 07 D0 9D 96 6B 2E 30 F7 54 C4 A5 CD 9B 13 54 
A0 D1 71 66 91 97 06 12 B5 2D B2 33 62 FB 56 62 
64 A8 AA E9 F2 F4 03 C3 F4 49 2A 09 0D 7D 75 99 
6C F0 47 1E 7D D5 A5 CA CE EF 45 B2 DA 88 93 B4 
EE EB FB B0 A6 A4 19 C4 B8 0D 04 46 AE BD C5 2E 
30 84 49 57 25 34 78 E6 ED C4 50 AF 3B F6 86 43 

At least this has been like this since before the git history, so it
isn't recent..

Can these be scheduled for removal or some such process? I haven't
seen anything actually using the files, the only one that is really
useful is caps...

They probably should have been in debugfs, had it existed at the time.

Thanks,
Jason
