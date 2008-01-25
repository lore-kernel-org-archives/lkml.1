Return-Path: <linux-kernel-owner+w=401wt.eu-S1757166AbYAYWPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbYAYWPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:15:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbYAYWO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:14:58 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:44260 "EHLO
	outbound5-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753954AbYAYWO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:14:56 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Date: Fri, 25 Jan 2008 23:10:29 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Anthony Liguori" <anthony@codemonkey.ws>
cc: "Avi Kivity" <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 3/8] SVM: add module parameter to
 disable Nested Paging
Message-ID: <20080125221029.GA23111@amd.com>
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
 <1201294393-22613-4-git-send-email-joerg.roedel@amd.com>
 <479A561B.8070009@codemonkey.ws>
MIME-Version: 1.0
In-Reply-To: <479A561B.8070009@codemonkey.ws>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 25 Jan 2008 22:10:29.0783 (UTC)
 FILETIME=[18A2F270:01C85F9F]
X-WSS-ID: 6B8481FC2IW8836763-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 03:35:23PM -0600, Anthony Liguori wrote:
> Joerg Roedel wrote:
> >To disable the use of the Nested Paging feature even if it is available in
> >hardware this patch adds a module parameter. Nested Paging can be disabled by
> >passing npt=off to the kvm_amd module.
> >
> >Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> >---
> > arch/x86/kvm/svm.c |    8 ++++++++
> > 1 files changed, 8 insertions(+), 0 deletions(-)
> >
> >diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> >index 49bb57a..2e718ff 100644
> >--- a/arch/x86/kvm/svm.c
> >+++ b/arch/x86/kvm/svm.c
> >@@ -48,6 +48,9 @@ MODULE_LICENSE("GPL");
> > #define SVM_DEATURE_SVML (1 << 2)
> >  static bool npt_enabled = false;
> >+static char *npt = "on";
> >+
> >+module_param(npt, charp, S_IRUGO);
> >  
> 
> This would probably be better as an integer.  Then we don't have to do nasty things like 
> implicitly cast a literal to a char *.

Hmm, I used int for that first but typing npt=off seemed more
userfriendly to me than npt=0. So I used char* for it.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


