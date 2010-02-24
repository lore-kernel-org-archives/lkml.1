Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab0BXThN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 14:37:13 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:46556
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757736Ab0BXThL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 14:37:11 -0500
X-SpamScore: -15
X-BigFish: VPS-15(zz1432R98dNzz1202hzzz32i6bh87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYD2HM-02-WV2-02
X-M-MSG: 
Date: Wed, 24 Feb 2010 20:37:01 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Alexander Graf <agraf@suse.de>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] KVM: SVM: Optimize nested svm msrpm merging
Message-ID: <20100224193700.GE3168@amd.com>
References: <1267034360-5907-1-git-send-email-joerg.roedel@amd.com>
 <1267034360-5907-12-git-send-email-joerg.roedel@amd.com>
 <402BABD5-304A-47EA-B35C-D0E3948BB27E@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <402BABD5-304A-47EA-B35C-D0E3948BB27E@suse.de>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 24 Feb 2010 19:37:01.0185 (UTC) FILETIME=[BC3E2710:01CAB588]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 08:27:50PM +0100, Alexander Graf wrote:
> > +	static const u32 msrpm_offsets[] = {
> > +		0x0000002c, /* SYSENTER_CS */
> > +
> > +		0x00000038, /* LASTBRANCHFROMIP
> > +			       LASTBRANCHTOIP
> > +			       LASTINTFROMIP
> > +			       LASTINTTOIP */
> > +
> > +		0x00000820, /* STAR
> > +			       LSTAR
> > +			       CSTAR
> > +			       SYSCALL_MASK */
> > +
> > +		0x00000840, /* FS_BASE
> > +			       GS_BASE
> > +			       KERNEL_GS_BASE */
> > +
> > +		0xffffffff, /* End of List */
> 
> Isn't there such a list around somewhere already? We really should
> only keep this list once throughout the whole code. If necessary, just
> create the list on the fly when bits get set in the msrpm.

No, the list is hardcoded in 3 functions (as parameter of
set_msr_interception). I think about a variant to do this with a single
list. Probably I create a list of MSRs and check in
set_msr_interceptionm for it.

	Joerg


