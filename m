Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbYBHXxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbYBHXxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYBHXxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:53:44 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:36980 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753750AbYBHXxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:53:43 -0500
X-YMail-OSG: En99cqcVM1mcQbCzJ.vxf_a8iEgqciXzrlh23KIRsYx0JKAYb1s87wpKCmIoMfVJRhy1SMUKIw--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: Integration of SCST in the mainstream Linux kernel
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: david@lang.hm, Bart Van Assche <bart.vanassche@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       scst-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <47AC6908.7060809@vlnb.net>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain> <47A751C5.60600@vlnb.net>
	 <1202149322.3096.66.camel@localhost.localdomain>
	 <47A75B8A.3020503@vlnb.net>
	 <1202151293.3096.80.camel@localhost.localdomain>
	 <47A8B210.8040202@vlnb.net>
	 <1202238802.3133.71.camel@localhost.localdomain>
	 <e2e108260802070513t4eeb9a9fucfe9821d94bd7f82@mail.gmail.com>
	 <47AB0B63.20500@vlnb.net>
	 <alpine.DEB.1.00.0802071437404.12791@asgard.lang.hm>
	 <1202470395.1805.127.camel@haakon2.linux-iscsi.org>
	 <47AC6908.7060809@vlnb.net>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 15:53:03 -0800
Message-Id: <1202514783.1805.159.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-08 at 17:36 +0300, Vladislav Bolkhovitin wrote:
> Nicholas A. Bellinger wrote:
> >>>>- It has been discussed which iSCSI target implementation should be in
> >>>>the mainstream Linux kernel. There is no agreement on this subject
> >>>>yet. The short-term options are as follows:
> >>>>1) Do not integrate any new iSCSI target implementation in the
> >>>>mainstream Linux kernel.
> >>>>2) Add one of the existing in-kernel iSCSI target implementations to
> >>>>the kernel, e.g. SCST or PyX/LIO.
> >>>>3) Create a new in-kernel iSCSI target implementation that combines
> >>>>the advantages of the existing iSCSI kernel target implementations
> >>>>(iETD, STGT, SCST and PyX/LIO).
> >>>>
> >>>>As an iSCSI user, I prefer option (3). The big question is whether the
> >>>>various storage target authors agree with this ?
> >>>
> >>>I tend to agree with some important notes:
> >>>
> >>>1. IET should be excluded from this list, iSCSI-SCST is IET updated for SCST 
> >>>framework with a lot of bugfixes and improvements.
> >>>
> >>>2. I think, everybody will agree that Linux iSCSI target should work over 
> >>>some standard SCSI target framework. Hence the choice gets narrower: SCST vs 
> >>>STGT. I don't think there's a way for a dedicated iSCSI target (i.e. PyX/LIO) 
> >>>in the mainline, because of a lot of code duplication. Nicholas could decide 
> >>>to move to either existing framework (although, frankly, I don't think 
> >>>there's a possibility for in-kernel iSCSI target and user space SCSI target 
> >>>framework) and if he decide to go with SCST, I'll be glad to offer my help 
> >>>and support and wouldn't care if LIO-SCST eventually replaced iSCSI-SCST. The 
> >>>better one should win.
> >>
> >>why should linux as an iSCSI target be limited to passthrough to a SCSI 
> >>device.
> > 
> > <nod>
> > 
> > I don't think anyone is saying it should be.  It makes sense that the
> > more mature SCSI engines that have working code will be providing alot
> > of the foundation as we talk about options..
> > 
> >>From comparing the designs of SCST and LIO-SE, we know that SCST has
> > supports very SCSI specific target mode hardware, including software
> > target mode forks of other kernel code.  This code for the target mode
> > pSCSI, FC and SAS control paths (more for the state machines, that CDB
> > emulation) that will most likely never need to be emulated on non SCSI
> > target engine.
> 
> ...but required for SCSI. So, it must be, anyway.
> 
> > SCST has support for the most SCSI fabric protocols of
> > the group (although it is lacking iSER) while the LIO-SE only supports
> > traditional iSCSI using Linux/IP (this means TCP, SCTP and IPv6).  The
> > design of LIO-SE was to make every iSCSI initiator that sends SCSI CDBs
> > and data to talk to every potential device in the Linux storage stack on
> > the largest amount of hardware architectures possible.
> > 
> > Most of the iSCSI Initiators I know (including non Linux) do not rely on
> > heavy SCSI task management, and I think this would be a lower priority
> > item to get real SCSI specific recovery in the traditional iSCSI target
> > for users.  Espically things like SCSI target mode queue locking
> > (affectionally called Auto Contingent Allegiance) make no sense for
> > traditional iSCSI or iSER, because CmdSN rules are doing this for us.
> 
> Sorry, it isn't correct. ACA provides possibility to lock commands queue 
> in case of CHECK CONDITION, so allows to keep commands execution order 
> in case of errors. CmdSN keeps commands execution order only in case of 
> success, in case of error the next queued command will be executed 
> immediately after the failed one, although application might require to 
> have all subsequent after the failed one commands aborted. Think about 
> journaled file systems, for instance. Also ACA allows to retry the 
> failed command and then resume the queue.
> 

Fair enough.  The point I was making is that I have never actually seen
an iSCSI Initiator use ACA functionality (I don't believe that the Linux
SCSI Ml implements this), or actually generate a CLEAR_ACA task
management request.

--nab

> Vlad
> 

