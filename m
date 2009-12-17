Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbZLQDHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbZLQDHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 22:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757473AbZLQDHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 22:07:14 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:45351 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbZLQDHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 22:07:12 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: radeon KMS causes GART Table Walk Errors (was: K8 ECC error with linux-2.6.32)
Date: Thu, 17 Dec 2009 04:07:04 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32; KDE/4.3.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de> <200912161558.30819.johannes.hirte@fem.tu-ilmenau.de> <20091216164156.GF11618@aftab>
In-Reply-To: <20091216164156.GF11618@aftab>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912170407.04568.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 16 Dezember 2009 17:41:56 schrieb Borislav Petkov:
> On Wed, Dec 16, 2009 at 03:58:30PM +0100, Johannes Hirte wrote:
> > Am Mittwoch 16 Dezember 2009 08:14:43 schrieb Borislav Petkov:
> > > On Tue, Dec 15, 2009 at 11:00:46PM +0100, Johannes Hirte wrote:
> > > > This patch (as the BIOS option) will only disable the error reports.
> > > > The error itself will still occur, right? So necessary to find out
> > > > why the radeon driver trigger this error.
> > >
> > > Because the graphics driver does aperture accesses with no
> > > matching GART translation, and the hw generates mchecks for
> > > that. The whole story on GART table walk errors is in section
> > > "13.10.1 GART Table Walk Error Reporting" in the document here:
> > > http://support.amd.com/us/Processor_TechDocs/32559.pdf
> > >
> > > I can't say for sure about your BIOS, but if it is done as described in
> > > the abovementioned section, the BIOS option should disable logging of
> > > the error, which implies reporting too.
> > >
> > > The patch is still needed for machines that do not have that BIOS
> > > option.
> >
> > Disabling in BIOS doesn't made any difference. The errors were still
> > reported.
> 
> Hmm. It would be interesting to know what the BIOS does exactly
> on your machine. We could easily find that out by installing the
> x86info tool (either prepackaged for your distro or from here:
> git://git.choralone.org/git/x86info) and doing as root:
> 
> lsmsr MC4 -V3
> 
> and sending me the output. Make sure the amd64_edac module is not loaded.

datengrab ~ # lsmsr MC4 -V3    
MC4_CTL              = 0x0000000000003bff
  CorrEccEn=0x1                          
  UnCorrEccEn=0x1                        
  CrcErr0En=0x1                          
  CrcErr1En=0x1                          
  CrcErr2En=0x1                          
  SyncPkt0En=0x1                         
  SyncPkt1En=0x1
  SyncPkt2En=0x1
  MstrAbrtEn=0x1
  TgtAbrtEn=0x1
  GartTblWkEn=0
  AtomicRMWEn=0x1
  WchDogTmrEn=0x1
  DramParEn=0
MC4_STATUS           = 0x0000000000000000
  ErrorCode=0
  ErrorCodeExt=0
  Syndrome=0
  ErrCpu0=0
  ErrCpu1=0
  LDTLink=0
  ErrScrub=0
  DramChannel=0
  UnCorrECC=0
  CorrECC=0
  ECC_Synd=0
  PCC=0
  ErrAddrVal=0
  ErrMiscVal=0
  ErrEn=0
  ErrUnCorr=0
  ErrOver=0
  ErrValid=0
MC4_ADDR             = 0x0000000090063a20
  ADDR=0x1200c744
MC4_MISC             = 0x0000000000000000
  ErrCount=0
  Ovrflw=0
  IntType=0
  CntEn=0
  LvtOff=0
  Locked=0
  CtrP=0
  Val=0
MC4_CTL_MASK         = 0x0000000000000400
  CorrEccEn=0
  UnCorrEccEn=0
  CrcErr0En=0
  CrcErr1En=0
  CrcErr2En=0
  SyncPkt0En=0
  SyncPkt1En=0
  SyncPkt2En=0
  MstrAbrtEn=0
  TgtAbrtEn=0
  GartTblWkEn=0x1
  AtomicRMWEn=0
  WchDogTmrEn=0
  DramParEn=0

> > Your patch disabled it.
> 
> Thanks for testing.
> 
> > But I think this will make work harder for driver developers as
> > they won't get this error anymore. Could this be made changeable on
> > runtime/boottime?
> 
> yep, we have that. You have to set 'report_gart_errors' module parameter
> to 1 when loading amd64_edac and GART TLB errors will be reported.

Thanks, I should read the sources more carefully.

regards,
  Johannes
