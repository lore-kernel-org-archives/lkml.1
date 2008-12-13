Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbYLMKDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbYLMKDV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 05:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbYLMKDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 05:03:11 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:28316 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755116AbYLMKDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 05:03:10 -0500
X-YMail-OSG: th.3TpEVM1k_u__EpOwbpQRfdHiOQrMgZabMpjX1oDlsZBVpTJlIGeKJiDwVprBrZtsGytARNWtBMZoMi1tNpR_jUbQzs3vRxO8UZ9Ksq8QAqJGilNWzVV7p7k4vzBZB9AWX1DaapRR7ZDkEeDfYmWiM1dFAWAueq2jYrPbIIC.nIOPI4WTBDdjU0eI5KFUcnJOzjGuHNrX2ys_p_P8Jg31VbpZiOU9BUwcz
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH][RFC 21/23]: iSCSI target driver
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4942BADE.5010907@vlnb.net>
References: <494009D7.4020602@vlnb.net>  <49401205.8010207@vlnb.net>
	 <1229036109.4153.585.camel@haakon2.linux-iscsi.org>
	 <4942BADE.5010907@vlnb.net>
Content-Type: text/plain
Date: Sat, 13 Dec 2008 02:03:06 -0800
Message-Id: <1229162586.4153.851.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-12 at 22:26 +0300, Vladislav Bolkhovitin wrote:
> Nicholas A. Bellinger wrote:
> > On Wed, 2008-12-10 at 22:01 +0300, Vladislav Bolkhovitin wrote:
> >> This patch contains iSCSI-SCST target driver. This driver is a heavily 
> >> modified forked with all respects IET 
> >> (http://iscsitarget.sourceforge.net). Modifications were aimed to make a 
> >> clearer, more reviewable and maintainable code as well as to fix many 
> >> problems and make many improvements. See 
> >> http://scst.sourceforge.net/target_iscsi.html for more details.
> >>
> >> It has split user/kernel space architecture, where all management, 
> >> sessions creation, parameters negotiation, etc. made in user space and 
> >> data are transferred in the kernel space. Such architecture for iSCSI 
> >> processing was many times acknowledged as the right one. Particularly, 
> >> in-kernel iSCSI initiator (open-iscsi) has such architecture.
> >>
> > 
> > Just as with the Open/iSCSI Initiator, IMHO I believe the split
> > architecture design is difficult both to improve, debug and maintain,
> > and provides *ZERO* additional benefit in the context of traditional
> > iSCSI target mode for doing login and connection/session setup in
> > userspace.
> > 
> > Also, I appericate that you spent alot of time porting over IET code to
> > your engine, but during our previous discussion you did not seem
> > terribly interested in validation against core-iscsi-dv
> > (http://linux-iscsi.org/index.php/Core-iscsi-dv) to test RFC-3720
> > interopt and stability.  Because the Core-iSCSI Initiator supports every
> > possible parameter combination up to ErrorRecoveryLevel=0 defined in
> > RFC-3720, the Core-iSCSI-Dv tests can run badblocks (or any too) to
> > check data integrity for *EVERY* possible traditional iSCSI key
> > combination and functionality for your iSCSI-SCST work, and any type of
> > serious iSCSI-SCST production deployments.
> 
> The fact that nobody so far cared to do all those complicated and time 
> consuming rather academic tests doesn't mean that iSCSI-SCST won't pass 
> them. IET/iSCSI-SCST have been used for a long time in very different 
> setups, including xBSD and Solaris initiators on non-x86 architectures, 
> without any problems.
> 

Heh, nice try.

Considering that core-iscsi-dv is used for validating the production
systems used for Linux-iSCSI.org services, I would hardly consider self
hosted usage of LIO-Target (eg: actually using code we write for public
project services) an "academic" endevour.  Last time I checked you where
iSCSI-SCST was not running self-hosted production for your own project,
so I hardly think you are in a place to judge which RFC-3720 domain
validation tests are of worth or not.

Anyways, you having to guess about if your iSCSI target code will pass a
RFC-3720 compliance hardly makes it mainline material.   Considering
that iSCSI-SCST has never been independently reviewed for RFC-3720
compliance (as LIO-Target has) and never has had an iSCSI Initiator
doing non-selective iSCSI parameter domain validation (as LIO-Target
has), I find your claim of iSCSI-SCST RFC completeness and maturity a
dubious proposition at best.  To this day I have not seen a single
iSCSI-SCST production setup anywhere, nor have I heard anyone
considering moving into it into any serious production environments.

Certainly iSCSI-SCST is lacking in the traditional iSCSI feature
department: no MC/S or ErrorRecoveryLevel=2 , features from RFC-3720
that apply to iSER/IB and iSER/DDP, and will be included in LIO-iSER
code in 2009.  Considering that you have not implemented your own iSCSI
Initiator or contributed any code to the Open/iSCSI Initiator project,
seeing how these RFC-3720 production ready features would arrive in
iSCSI-SCST code any time soon is a strech of the imagination.

That said, I do understand that you spent a number of months adapting
the code from the IET project after your disagreements in that community
caused you to fork their code as iSCSI-SCST.  I think having multiple
open source iSCSI targets is a GOOD thing, and I am not going to try to
convience you that you should stop working on iSCSI-SCST.  However,
please understand that I have been doing nothing but iSCSI since 2001,
and that the LIO-Target base code has been running in customer
production since 2004.  Not to mention a team of senior folks working
full time on the code from 2005-2007, including a new team of senior
devels who will be working on it full time in 2009 as the upstream
process continues.

So, again, I really apperciate your work both with SCST Core and
iSCSI-SCST, but the song and dance of iSCSI-SCST of being comparable in
maturity, feature completeness, or production track record to LIO-Target
is just that, a song and dance.  Why..?  Aside from the years of
commerical effort, resources and validation put into the LIO-Target
codebase, I do not have to guess about how RFC-3720 compliance will turn
out for LIO-Target.  I wrote a iSCSI Initiator and domain validation
tool in parallel with LIO-Target to actually prove it to myself years
ago.  So far, you have been unwilling and / or unable to prove on even
the most basic RFC-3720 functionality with your work.

Regards,

--nab 

> Vlad
> 
> 

