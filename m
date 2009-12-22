Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbZLVPbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbZLVPbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 10:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbZLVPbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 10:31:16 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:57034
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751283AbZLVPbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 10:31:15 -0500
X-SpamScore: -9
X-BigFish: VPS-9(zf7Iz98dNaccKzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KV28FO-01-UYD-02
X-M-MSG: 
Date: Tue, 22 Dec 2009 16:30:59 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Zachary Amsden <zamsden@redhat.com>
CC: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Dor Laor <dlaor@redhat.com>,
       Joerg Roedel <joro@8bytes.org>
Subject: Re: Fwd: RFC - TSC virtualization for KVM
Message-ID: <20091222153059.GE14679@amd.com>
References: <4B271B6F.4000408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B271B6F.4000408@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 22 Dec 2009 15:31:00.0346 (UTC) FILETIME=[C3A8DDA0:01CA831B]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zachary,

On Mon, Dec 14, 2009 at 07:15:27PM -1000, Zachary Amsden wrote:
> The overall goal is to have a stable platform TSC and a mixed set of
> virtualization approaches that can be tailored for the need of the particular
> operating system running, which runs on systems regardless of hardware TSC
> frequency changes, CPU hotplug, or destabilization events, and which allows
> virtualization of multiple different TSC speeds.  I realize this is ambitious,
> but it is achievable, and I believe these patches provide a solid foundation.

I have some high-level comments on your patchset. 

First, I like the idea of introducing a new ioctl to set the guest tsc
rate. But I think it could be a little bit simpler. How about a single
__u32 parameter instead of a struct. This parameter is the tsc rate for
the guest in khz. If this value is configured to be 0 this means the cpu
tsc frequency should be used.

Second, the patchset implements very sophisticated code to keep the tsc
of different cpus synchronized. This code looks a bit fragile to me, it
does not protect against SMI or NMI (and there is no way to do so).
Have you thought about using the kernel system time as a reference and
calculate a tsc value for the vcpu? The kernel timekeeping solves most
of the problems you have here already.

Regards,

	Joerg


