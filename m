Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936226Ab0BZNWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 08:22:22 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:22313
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S936021Ab0BZNWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 08:22:20 -0500
X-SpamScore: -28
X-BigFish: VPS-28(zz1432R98dN936eM9371Pzz1202hzzz32i87h6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYGAFH-02-7VZ-02
X-M-MSG: 
Date: Fri, 26 Feb 2010 14:21:18 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] KVM: SVM: Optimize nested svm msrpm merging
Message-ID: <20100226132118.GF12689@amd.com>
References: <1267118149-15737-1-git-send-email-joerg.roedel@amd.com>
 <1267118149-15737-3-git-send-email-joerg.roedel@amd.com>
 <4B87A248.1050300@redhat.com>
 <20100226122502.GC12689@amd.com>
 <4E7D93ED-E5FC-4A64-B9B0-E2F644CD2B68@suse.de>
 <20100226130401.GD12689@amd.com>
 <4B87C835.4080409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4B87C835.4080409@redhat.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 26 Feb 2010 13:21:18.0734 (UTC) FILETIME=[94B89AE0:01CAB6E6]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 03:10:13PM +0200, Avi Kivity wrote:
> On 02/26/2010 03:04 PM, Joerg Roedel wrote:
> >
> >>I'm still not convinced on this way of doing things. If it's static,
> >>make it static. If it's dynamic, make it dynamic. Dynamically
> >>generating a static list just sounds plain wrong to me.
> >Stop. I had a static list in the first version of the patch. This list
> >was fine except the fact that a developer needs to remember to update
> >this list if the list of non-intercepted msrs is expanded. The whole
> >reason for a dynamically built list is to take the task of maintaining
> >the list away from the developer and remove a possible source of hard to
> >find bugs. This is what the current approach does.
> 
> The problem was the two lists.  If you had a
> 
> static struct svm_direct_access_msrs = {
>     u32 index;
>     bool longmode_only;
> } direct_access_msrs = {
>    ...
> };
> 
> You could generate
> 
> static unsigned *msrpm_offsets_longmode, *msrpm_offsets_legacy;
> 
> as well as the original bitmaps at module init, no?

True for the msrs the guest always has access too. But for the lbr-msrs
the intercept bits may change at runtime. So an addtional flag is
required to indicate if the bits should be cleared initially.

	Joerg


